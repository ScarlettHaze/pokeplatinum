"""Use HGSS's signpost graphics: the frame, the palette and the pictures on map
and arrow signs.

Both games keep them in one archive laid out the same way: the frame, the
palette, 31 arrow sign pictures, then the map sign pictures (19 in Platinum,
21 in HGSS). Kanto replaces Sinnoh, so HGSS's replace Platinum's and the two
extra map sign pictures are appended. A sign's picture number then means the
same in both games.
"""
import struct
from pathlib import Path

from PIL import Image

import narc

PL = Path(__file__).resolve().parents[2]
SIGNPOSTS = PL / "res/graphics/signposts"
HGSS_BOARD = "files/a/0/3/6"
ROUTES = 31
TILE = 8


def chunk(data, magic):
    off = struct.unpack_from("<H", data, 0xC)[0]
    assert data[off:off + 4] == magic
    return off


def ncgr_to_png(data, palette, path):
    off = chunk(data, b"RAHC")
    height, width, depth, _, _, size, _ = struct.unpack_from("<HHIIIII", data, off + 8)
    assert depth == 3, "4 bpp"
    tiles = data[off + 0x20:off + 0x20 + size]
    img = Image.new("P", (width * TILE, height * TILE))
    img.putpalette([v for c in palette for v in c])
    px = img.load()
    for t in range(width * height):
        for i in range(32):
            b = tiles[t * 32 + i]
            x, y = (t % width) * TILE + (i % 4) * 2, (t // width) * TILE + i // 4
            px[x, y], px[x + 1, y] = b & 15, b >> 4
    img.save(path)


def read_palette(data):
    off = chunk(data, b"TTLP")
    size = struct.unpack_from("<I", data, off + 0x10)[0]
    colors = struct.unpack_from(f"<{size // 2}H", data, off + 0x18)
    return [((c & 31) * 255 // 31, (c >> 5 & 31) * 255 // 31, (c >> 10 & 31) * 255 // 31) for c in colors]


def import_signs(hg):
    members = narc.read_narc(Path(hg) / HGSS_BOARD)
    palette = read_palette(members[1])
    (SIGNPOSTS / "signpost.pal").write_text(
        "JASC-PAL\r\n0100\r\n%d\r\n" % len(palette) + "".join("%d %d %d\r\n" % c for c in palette))
    rows = [palette[i:i + 16] for i in range(0, len(palette), 16)]
    ncgr_to_png(members[0], rows[0], SIGNPOSTS / "signpost_frame.png")
    city_names = [l.removesuffix(".NCGR") for l in (SIGNPOSTS / "field_board.order").read_text().split()
                  if l.startswith("city_map_")]
    for i in range(ROUTES):
        ncgr_to_png(members[2 + i], rows[1], SIGNPOSTS / f"route_map_{i:02d}.png")
    cities = members[2 + ROUTES:]
    extra = []
    for i, data in enumerate(cities):
        name = city_names[i] if i < len(city_names) else f"city_map_kanto_{i:02d}"
        if i >= len(city_names):
            extra.append(name)
        ncgr_to_png(data, rows[0], SIGNPOSTS / f"{name}.png")
    # The extra pictures follow the last map sign picture.
    order = [l for l in (SIGNPOSTS / "field_board.order").read_text().split() if not l.startswith("city_map_kanto_")]
    (SIGNPOSTS / "field_board.order").write_text("\n".join(order + [f"{n}.NCGR" for n in extra]) + "\n")
    meson = (SIGNPOSTS / "meson.build").read_text().splitlines()
    meson = [l for l in meson if "city_map_kanto_" not in l]
    at = next(i for i, l in enumerate(meson) if "'city_map_fight_area.png'" in l) + 1
    meson[at:at] = [f"    '{n}.png'," for n in extra]
    (SIGNPOSTS / "meson.build").write_text("\n".join(meson) + "\n")
    return len(cities)
