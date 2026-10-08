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

Sinnoh's per-block signposts and descriptions are dropped: HGSS's map has
none, and their positions are Sinnoh's.

Usage: tools/hgss_import/import_kanto_town_map.py <path-to-pokeheartgold>
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
    sys.exit(f"the map's colors do not fit in {len(PALETTE_SLOTS)} palettes")


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
        assert len(self.tiles) <= 1024
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


def build_top(hgss, palettes):
    tileset = Tileset(palettes)
    entries = []
    ox, oy = TOP_ORIGIN[0] // 8, TOP_ORIGIN[1] // 8
    for ty in range(24):
        for tx in range(32):
            entries.append(tileset.add(hgss.block_tile(tx - ox, ty - oy)))
    tileset.save(TOWN_MAP / "top_screen_map_tiles.png")
    for name, data in (("top_screen_region_map_tilemap.NSCR", entries), ("top_screen_region_bg_tilemap.NSCR", [0] * 768)):
        path = TOWN_MAP / name
        path.write_bytes(write_nscr(path.read_bytes(), data))
    return len(tileset.tiles)


def build_zoomed(hgss, palettes):
    tileset = Tileset(palettes)
    entries = []
    ox, oy = ZOOMED_ORIGIN[0] // 16, ZOOMED_ORIGIN[1] // 16
    for ty in range(64):
        for tx in range(64):
            # Each map tile becomes 2x2 zoomed tiles.
            src = hgss.block_tile(tx // 2 - ox, ty // 2 - oy)
            qx, qy = (tx % 2) * 4, (ty % 2) * 4
            entries.append(tileset.add(src[(qy + y // 2) * 8 + qx + x // 2] for y in range(8) for x in range(8)))
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


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hgss = HgssMap(Path(parser.parse_args().hgss))
    # Every block either screen shows (see build_top and build_zoomed).
    palettes = pack_palettes(hgss.block_tile(x, y) for x in range(-3, 29) for y in range(-3, 29))
    top, zoomed = build_top(hgss, palettes), build_zoomed(hgss, palettes)
    update_palettes(palettes)
    drop_sinnoh_blocks()
    print(f"top screen: {top} tiles, zoomed in: {zoomed} tiles")


if __name__ == "__main__":
    main()
