#!/usr/bin/env python3
"""Draw Kanto on the Town Map, from HGSS's Pokégear map.

HGSS's Pokégear map (pgmap_gra 10/11, palette 20) is one picture of Johto
and Kanto at 8 pixels per world matrix block, two rows below the matrix.
The Kanto part is cut out along the imported world matrix (import_kanto.py's
KANTO_WORLD_X/Y) and becomes:

- the top screen map, at 8 pixels per block, block (0, 0) at TOP_ORIGIN;
- the zoomed in bottom screen map, at 16 pixels per block (the Town Map's
  zoom), block (0, 0) at ZOOMED_ORIGIN.

These origins are mirrored by TOWN_MAP_GRID_* and TOWN_MAP_ZOOMED_* in
include/applications/town_map/defs.h. The map only uses palette 0 of HGSS's;
it replaces palette 0 of the Town Map's map palettes.

Both screens are drawn from one 256x256 picture, kanto_town_map.png, at 8
pixels per block with block (0, 0) at TOP_ORIGIN. The top screen shows its
top 192 rows; the zoomed in map shows all of it at double size. The import
saves that picture, and --png rebuilds the Town Map from an edited copy.
Colors are rounded to the DS's 15 bit colors. Each 8x8 tile can use up to 15
colors, and the whole picture up to 45, split into 3 palettes of 15 so every
tile fits one of them.

Sinnoh's per-block signposts and descriptions are dropped: HGSS's map has
none, and their positions are Sinnoh's.

Usage:
tools/hgss_import/import_kanto_town_map.py <path-to-pokeheartgold>
tools/hgss_import/import_kanto_town_map.py --png <edited kanto_town_map.png>
"""
import argparse
import json
import random
import struct
import sys
import zlib
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).parent))
from import_kanto import KANTO_WORLD_X, KANTO_WORLD_Y  # noqa: E402

PL = Path(__file__).resolve().parents[2]
TOWN_MAP = PL / "res/graphics/town_map"
PGMAP = "files/application/pokegear/map/pgmap_gra/pgmap_gra_%08d.%s"

HGSS_MAP_ROW_OFFSET = 2  # map row = world matrix row + 2
TOP_ORIGIN = (24, 24)
ZOOMED_ORIGIN = (48, 48)
# A sea tile of HGSS's map, drawn around the part HGSS's map covers.
SEA = (46, 19)
PALETTE_SLOTS = (0, 1, 5)
PICTURE = Path(__file__).parent / "kanto_town_map.png"
PICTURE_SIZE = 256


def read_nscr(data):
    off = struct.unpack_from("<H", data, 0xC)[0]
    width, height, _, size = struct.unpack_from("<HHII", data, off + 8)
    return width, height, list(struct.unpack_from(f"<{size // 2}H", data, off + 0x14))


def write_nscr(template, entries):
    """Reuse a Platinum NSCR's headers (same size) with new entries."""
    off = struct.unpack_from("<H", template, 0xC)[0]
    body = struct.pack(f"<{len(entries)}H", *entries)
    assert len(template) == off + 0x14 + len(body)
    return template[:off + 0x14] + body


def read_nclr(data):
    off = struct.unpack_from("<H", data, 0xC)[0]
    size = struct.unpack_from("<I", data, off + 0x10)[0]
    colors = struct.unpack_from(f"<{size // 2}H", data, off + 0x18)
    return [((c & 31) * 8, ((c >> 5) & 31) * 8, ((c >> 10) & 31) * 8) for c in colors]


def write_jasc(path, colors):
    path.write_text("JASC-PAL\r\n0100\r\n%d\r\n" % len(colors) + "".join("%d %d %d\r\n" % c for c in colors))


class HgssMap:
    def __init__(self, hg):
        sheet = Image.open(hg / (PGMAP % (10, "png")))
        width = sheet.size[0] // 8
        px = sheet.load()
        palette = read_nclr((hg / (PGMAP % (20, "NCLR"))).read_bytes())
        # 8 bits per pixel: tiles hold colors.
        self.tiles = [[palette[px[(t % width) * 8 + x, (t // width) * 8 + y]] for y in range(8) for x in range(8)]
                      for t in range(width * (sheet.size[1] // 8))]
        self.width, self.height, self.entries = read_nscr((hg / (PGMAP % (11, "NSCR"))).read_bytes())
        # The map itself; the rest of the screen holds the Pokégear's parts.
        self.map_width, self.map_height = 47, 20

    def tile_pixels(self, x, y):
        if not (0 <= x < self.map_width and 0 <= y < self.map_height):
            x, y = SEA
        entry = self.entries[y * (self.width // 8) + x]
        tile = self.tiles[entry & 0x3FF]
        hflip, vflip = entry >> 10 & 1, entry >> 11 & 1
        return [tile[(7 - yy if vflip else yy) * 8 + (7 - xx if hflip else xx)] for yy in range(8) for xx in range(8)]

    def block_tile(self, bx, by):
        """Pixels of the 8x8 map tile drawn for imported matrix block (bx, by)."""
        return self.tile_pixels(KANTO_WORLD_X.start + bx, KANTO_WORLD_Y.start + by + HGSS_MAP_ROW_OFFSET)


def pack_palettes(color_sets):
    """Split the colors into 15 color palettes (index 0 is transparent) so each tile fits one."""
    sets = sorted({frozenset(c) for c in color_sets}, key=lambda c: (-len(c), sorted(c)))
    rng = random.Random(0)
    for attempt in range(10000):
        palettes = []
        for colors in sets:
            for palette in palettes:
                if len(palette | colors) <= 15:
                    palette |= colors
                    break
            else:
                palettes.append(set(colors))
        if len(palettes) <= len(PALETTE_SLOTS):
            return [sorted(p) for p in palettes]
        rng.shuffle(sets)
    sys.exit(f"the map's {len(set().union(*sets))} colors do not fit in {len(PALETTE_SLOTS)} palettes of 15")


class Tileset:
    def __init__(self, palettes):
        self.palettes = palettes
        self.tiles = [tuple([0] * 64)]  # tile 0 stays transparent
        self.index = {self.tiles[0]: 0}

    def add(self, colors):
        """Add a tile of colors; returns its tilemap entry."""
        colors = list(colors)
        p = next(i for i, palette in enumerate(self.palettes) if set(colors) <= set(palette))
        pixels = tuple(self.palettes[p].index(c) + 1 for c in colors)
        if pixels not in self.index:
            self.index[pixels] = len(self.tiles)
            self.tiles.append(pixels)
        if len(self.tiles) > 1024:
            sys.exit("the map has more than 1024 different 8x8 tiles")
        return PALETTE_SLOTS[p] << 12 | self.index[pixels]

    def save(self, path, width=512):
        per_row = width // 8
        rows = (len(self.tiles) + per_row - 1) // per_row
        pixels = [[0] * width for _ in range(rows * 8)]
        for t, tile in enumerate(self.tiles):
            for i, v in enumerate(tile):
                pixels[(t // per_row) * 8 + i // 8][(t % per_row) * 8 + i % 8] = v
        write_png_4bpp_gray(path, pixels)


def write_png_4bpp_gray(path, pixels):
    """nitrogfx wants the 4 bit grayscale PNGs Platinum's tilesets use, which
    store 15 - color index."""
    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))
    height, width = len(pixels), len(pixels[0])
    raw = b"".join(b"\0" + bytes((15 - row[x]) << 4 | (15 - row[x + 1]) for x in range(0, width, 2)) for row in pixels)
    path.write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 4, 0, 0, 0, 0))
                     + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


def to_hardware_order(entries, width_tiles, height_tiles):
    """Row-major entries of a 512x512 map to its four 32x32 screen blocks."""
    out = []
    for by in range(0, height_tiles, 32):
        for bx in range(0, width_tiles, 32):
            for y in range(32):
                out += entries[(by + y) * width_tiles + bx:(by + y) * width_tiles + bx + 32]
    return out


def picture_tile(picture, tx, ty):
    """Colors of the picture's 8x8 tile (tx, ty)."""
    return [picture[ty * 8 + y][tx * 8 + x] for y in range(8) for x in range(8)]


def build_top(picture, palettes):
    tileset = Tileset(palettes)
    entries = []
    for ty in range(24):
        for tx in range(32):
            entries.append(tileset.add(picture_tile(picture, tx, ty)))
    tileset.save(TOWN_MAP / "top_screen_map_tiles.png")
    for name, data in (("top_screen_region_map_tilemap.NSCR", entries), ("top_screen_region_bg_tilemap.NSCR", [0] * 768)):
        path = TOWN_MAP / name
        path.write_bytes(write_nscr(path.read_bytes(), data))
    return len(tileset.tiles)


def build_zoomed(picture, palettes):
    tileset = Tileset(palettes)
    entries = []
    assert ZOOMED_ORIGIN == (2 * TOP_ORIGIN[0], 2 * TOP_ORIGIN[1])
    for ty in range(64):
        for tx in range(64):
            # Each 4x4 pixels of the picture become one zoomed tile.
            entries.append(tileset.add(picture[ty * 4 + y // 2][tx * 4 + x // 2] for y in range(8) for x in range(8)))
    tileset.save(TOWN_MAP / "bottom_screen_map_tiles.png")
    for name, data in (("bottom_screen_region_map_tilemap.NSCR", to_hardware_order(entries, 64, 64)),
                       ("bottom_screen_region_bg_tilemap.NSCR", [0] * 4096)):
        path = TOWN_MAP / name
        path.write_bytes(write_nscr(path.read_bytes(), data))
    return len(tileset.tiles)


def palette_colors(palette):
    return [(0, 0, 0)] + list(palette) + [(0, 0, 0)] * (15 - len(palette))


def update_palettes(palettes):
    slots = {slot: palette_colors(p) for slot, p in zip(PALETTE_SLOTS, palettes)}
    blank = [(0, 0, 0)] * 16
    top = sum((slots.get(i, blank) for i in range(max(PALETTE_SLOTS) + 1)), [])
    write_jasc(TOWN_MAP / "top_screen_map.pal", top)
    # The bottom screen's palette file is followed by the zoom button's
    # (slots 2 to 4) and then bottom_screen_map_kanto.pal (slot 5).
    assert PALETTE_SLOTS == (0, 1, 5)
    write_jasc(TOWN_MAP / "bottom_screen_map.pal", slots[0] + slots[1])
    write_jasc(TOWN_MAP / "bottom_screen_map_kanto.pal", slots[5])


def drop_sinnoh_blocks():
    path = PL / "res/town_map/town_map_data.json"
    data = json.loads(path.read_text())
    # Keep one block, moved off the map, as the game expects at least one.
    block = dict(data["blocks"][0], x=0xFFFF, z=0xFFFF, hidden_location=None, landmark=None)
    data["blocks"] = [block]
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def draw_picture(hgss):
    """The picture both screens show, drawn from HGSS's map: rows of colors."""
    ox, oy = TOP_ORIGIN[0] // 8, TOP_ORIGIN[1] // 8
    picture = [[None] * PICTURE_SIZE for _ in range(PICTURE_SIZE)]
    for by in range(PICTURE_SIZE // 8):
        for bx in range(PICTURE_SIZE // 8):
            for i, color in enumerate(hgss.block_tile(bx - ox, by - oy)):
                picture[by * 8 + i // 8][bx * 8 + i % 8] = color
    return picture


def save_picture(picture, path):
    """Save as a paletted PNG, so editors offer the map's own colors."""
    colors = sorted({c for row in picture for c in row})
    index = {c: i for i, c in enumerate(colors)}
    image = Image.new("P", (PICTURE_SIZE, PICTURE_SIZE))
    image.putpalette([v for c in colors for v in c])
    image.putdata([index[c] for row in picture for c in row])
    image.save(path, optimize=True)


def load_picture(path):
    image = Image.open(path).convert("RGB")
    if image.size != (PICTURE_SIZE, PICTURE_SIZE):
        sys.exit(f"{path} is {image.size[0]}x{image.size[1]}, not {PICTURE_SIZE}x{PICTURE_SIZE}")
    px = image.load()
    # The DS has 5 bits per channel.
    return [[tuple(v // 8 * 8 for v in px[x, y]) for x in range(PICTURE_SIZE)]
            for y in range(PICTURE_SIZE)]


def check_tile_colors(picture):
    for ty in range(PICTURE_SIZE // 8):
        for tx in range(PICTURE_SIZE // 8):
            colors = set(picture_tile(picture, tx, ty))
            if len(colors) > 15:
                sys.exit(f"the 8x8 tile at pixel ({tx * 8}, {ty * 8}) has {len(colors)} colors, more than 15")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("hgss", nargs="?", help="path to a pokeheartgold checkout")
    source.add_argument("--png", type=Path, help="build from an edited kanto_town_map.png")
    args = parser.parse_args()
    if args.png:
        picture = load_picture(args.png)
    else:
        picture = draw_picture(HgssMap(Path(args.hgss)))
    check_tile_colors(picture)
    palettes = pack_palettes(picture_tile(picture, x, y)
                             for x in range(PICTURE_SIZE // 8) for y in range(PICTURE_SIZE // 8))
    top, zoomed = build_top(picture, palettes), build_zoomed(picture, palettes)
    update_palettes(palettes)
    save_picture(picture, PICTURE)
    drop_sinnoh_blocks()
    print(f"top screen: {top} tiles, zoomed in: {zoomed} tiles")


if __name__ == "__main__":
    main()
