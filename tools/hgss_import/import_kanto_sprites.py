#!/usr/bin/env python3
"""Replace the player's overworld sprites with HGSS's Ethan and Lyra.

Both games build these sprites the same way (and from the same lineage):
one NSBTX per sprite set, 32x32 frames in a 16 color texture, named
<basename>.<frame + 1>. Platinum keeps them as PNGs with the frames stacked
top to bottom, so each HGSS NSBTX is unpacked into the matching PNG. A set
whose frame count differs is reported and left alone.

Usage: tools/hgss_import/import_kanto_sprites.py <path-to-pokeheartgold>
"""
import argparse
import re
import struct
import sys
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).parent))
import nsbtx  # noqa: E402

PL = Path(__file__).resolve().parents[2]
SPRITES = PL / "res/graphics/field_sprites/player"

# Platinum player sprite PNG -> HGSS MMODEL (include/constants/mmodel.h).
PLAYER_SPRITES = {
    "player_m": "MMODEL_HERO",
    "player_f": "MMODEL_HEROINE",
    "player_m_bike": "MMODEL_CYCLEHERO",
    "player_f_bike": "MMODEL_CYCLEHEROINE",
    "player_m_surf": "MMODEL_SWIMHERO",
    "player_f_surf": "MMODEL_SWIMHEROINE",
    "player_m_holding_pokeball": "MMODEL_SPHERO",
    "player_f_holding_pokeball": "MMODEL_SPHEROINE",
    "player_m_sprayduck": "MMODEL_WATERHERO",
    "player_f_sprayduck": "MMODEL_WATERHEROINE",
    "player_m_fishing": "MMODEL_FISHINGHERO",
    "player_f_fishing": "MMODEL_FISH_HEROINE",
    # HGSS checks the Pokégear where Platinum checks the Pokétch.
    "player_m_poketch": "MMODEL_POKEHERO",
    "player_f_poketch": "MMODEL_POKEHEROINE",
    "player_m_save": "MMODEL_SAVEHERO",
    "player_f_save": "MMODEL_SAVEHEROINE",
    "player_m_pokecenter_heal": "MMODEL_BANZAIHERO",
    "player_f_pokecenter_heal": "MMODEL_BANZAIHEROINE",
}


def mmodel_ids(hg):
    ids = {}
    for line in (hg / "include/constants/mmodel.h").read_text().splitlines():
        m = re.match(r"#define\s+(MMODEL_\w+)\s+(\d+)", line)
        if m:
            ids[m.group(1)] = int(m.group(2))
    return ids


def to_png(data, path):
    textures, palettes = nsbtx.read(data)
    frames = sorted(textures, key=lambda t: int(t[0].rsplit(".", 1)[1]))
    width, height = frames[0][2], frames[0][3]
    assert all(f[1] == 3 and f[2:4] == (width, height) for f in frames), "expected 16 color frames of one size"
    img = Image.new("P", (width, height * len(frames)))
    colors = struct.unpack("<16H", palettes[0][1])
    img.putpalette([v for c in colors for v in ((c & 31) << 3, (c >> 5 & 31) << 3, (c >> 10 & 31) << 3)])
    px = img.load()
    for k, (_, _, _, _, texels) in enumerate(frames):
        for i, b in enumerate(texels):
            x, y = (i * 2) % width, (i * 2) // width
            px[x, k * height + y] = b & 15
            px[x + 1, k * height + y] = b >> 4
    img.save(path)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss)
    ids = mmodel_ids(hg)
    for name, mmodel in PLAYER_SPRITES.items():
        data = (hg / f"files/data/mmodel/mmodel/mmodel_{ids[mmodel]:08d}.NSBTX").read_bytes()
        path = SPRITES / f"{name}.png"
        old_frames = Image.open(path).size[1] // 32
        new_frames = len(nsbtx.read(data)[0])
        if old_frames != new_frames:
            print(f"skipped {name}: HGSS has {new_frames} frames, Platinum {old_frames}")
            continue
        to_png(data, path)


if __name__ == "__main__":
    main()
