#!/usr/bin/env python3
"""Import HGSS's overworld sprites: the player's, and those of Kanto's NPCs.

The player's sprites (Ethan and Lyra) replace Platinum's player sprite PNGs.
Every other HGSS sprite placed on a Kanto map becomes OBJ_EVENT_GFX_KANTO_*
(see include/data/kanto_object_event_gfx.h), set up like Platinum's walking
NPCs. HGSS's 8 frame Pokémon have two frames per direction where NPCs have
four, so each direction's pair is repeated. Sprites Platinum already has an
equivalent of (OBJECT_EQUIVALENTS) and the script-set SPRITE_VAR_* are not
imported.

Both games build these sprites the same way (and from the same lineage):
one NSBTX per sprite set, 32x32 frames in a 16 color texture, named
<basename>.<frame + 1>. Platinum keeps them as PNGs with the frames stacked
top to bottom, so each HGSS NSBTX is unpacked into the matching PNG. A set
whose frame count differs is reported and left alone.

Usage: tools/hgss_import/import_kanto_sprites.py <path-to-pokeheartgold>
"""
import argparse
import json
import re
import struct
import sys
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).parent))
import nsbtx  # noqa: E402
from hgss_headers import load_headers  # noqa: E402


PL = Path(__file__).resolve().parents[2]
FIELD_SPRITES = PL / "res/graphics/field_sprites"
SPRITES = FIELD_SPRITES / "player"
GFX_PREFIX = "OBJ_EVENT_GFX_KANTO_"

# HGSS sprites Platinum has its own version of.
OBJECT_EQUIVALENTS = {
    "SPRITE_MONSTARBALL": "OBJ_EVENT_GFX_POKEBALL",
    "SPRITE_BREAKROCK": "OBJ_EVENT_GFX_ROCK_SMASH",
    "SPRITE_ROCK": "OBJ_EVENT_GFX_STRENGTH_BOULDER",
    "SPRITE_TREE": "OBJ_EVENT_GFX_CUT_TREE",
    "SPRITE_PCWOMAN1": "OBJ_EVENT_GFX_POKECENTER_NURSE",
}

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


def frames_of(data):
    textures, palettes = nsbtx.read(data)
    def frame_number(texture):
        suffix = texture[0].rsplit(".", 1)[-1]
        return int(suffix) if suffix.isdigit() else 0
    return sorted(textures, key=frame_number), palettes


def to_png(data, path, expand_two_frame_directions=False):
    frames, palettes = frames_of(data)
    if expand_two_frame_directions:
        # up, down, left, right: [a, b] -> [a, b, a, b]
        frames = [frames[2 * d + i % 2] for d in range(4) for i in range(4)]
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


def sprite_table(hg):
    text = (hg / "asm/overlay_01_sprite_data.s").read_text()
    table = {}
    for m in re.finditer(r"\.short (SPRITE_\w+), (MMODEL_\w+)", text):
        table.setdefault(m.group(1), m.group(2))
    return table


def kanto_sprites(hg):
    kanto = [h for h in load_headers(hg) if h["regionNo"] == "MAP_REGION_KANTO"]
    used = set()
    for bank in {h["eventsBank"] for h in kanto}:
        name = bank.removeprefix("NARC_zone_event_").removesuffix("_bin") + ".json"
        events = json.loads((hg / "files/fielddata/eventdata/zone_event" / name).read_text())
        used.update(o["spriteId"] for o in events.get("objects", []))
    return sorted(used)


def replace_lines(path, start_marker, end_marker, new_lines):
    """Replace previously generated kanto lines inside a block, before its end marker."""
    lines = [l for l in path.read_text().splitlines() if "kanto_" not in l.lower() or "KANTO_" in l and "MAP_HEADER" in l]
    start = next(i for i, l in enumerate(lines) if start_marker in l)
    end = next(i for i in range(start, len(lines)) if end_marker in lines[i])
    lines[end:end] = new_lines
    path.write_text("\n".join(lines) + "\n")


def import_npcs(hg, ids):
    table = sprite_table(hg)
    imported = []
    skipped = []
    for sprite in kanto_sprites(hg):
        if sprite in OBJECT_EQUIVALENTS or sprite.startswith("SPRITE_VAR_"):
            continue
        if sprite not in table:
            skipped.append((sprite, "not in HGSS's sprite table"))
            continue
        data = (hg / f"files/data/mmodel/mmodel/mmodel_{ids[table[sprite]]:08d}.NSBTX").read_bytes()
        frames, _ = frames_of(data)
        if any(f[1] != 3 or f[2:4] != (32, 32) for f in frames) or len(frames) not in (8, 16):
            skipped.append((sprite, f"{len(frames)} frames of {frames[0][2]}x{frames[0][3]}"))
            continue
        name = sprite.removeprefix("SPRITE_").lower()
        to_png(data, FIELD_SPRITES / "npc" / f"kanto_{name}.png", expand_two_frame_directions=len(frames) == 8)
        imported.append(name)

    # Field sprite archive and its build.
    replace_lines(FIELD_SPRITES / "meson.build", "field_sprites_textures_32_px_single_palette = [", "]",
                  [f"    {{ 'file': 'npc/kanto_{n}.png', 'basename': 'kanto_{n[:10]}'}}," for n in imported])
    order = FIELD_SPRITES / "field_sprites.order"
    lines = [l for l in order.read_text().splitlines() if not l.startswith("kanto_")]
    order.write_text("\n".join(lines + [f"kanto_{n}.nsbtx" for n in imported]) + "\n")

    gfx = PL / "generated/object_events_gfx.txt"
    lines = [l for l in gfx.read_text().splitlines() if not l.startswith(GFX_PREFIX)]
    at = next(i for i, l in enumerate(lines) if l.startswith("OBJ_EVENT_GFX_BERRY_SPROUT"))
    lines[at:at] = [GFX_PREFIX + n.upper() for n in imported]
    gfx.write_text("\n".join(lines) + "\n")

    def entries(fmt):
        return "".join(f"    {fmt.format(gfx=GFX_PREFIX + n.upper(), name=n)} \\\n" for n in imported)
    (PL / "include/data/kanto_object_event_gfx.h").write_text(
        "// Generated by tools/hgss_import/import_kanto_sprites.py, do not edit.\n"
        "// Kanto's NPC sprites from HGSS, set up like Platinum's walking NPCs.\n\n"
        "#define KANTO_OBJECT_EVENT_GFX_RENDERERS \\\n" + entries("{{ {gfx}, &Unk_ov5_021FAFD8 }},") + "\n"
        "#define KANTO_OBJECT_EVENT_GFX_TEXTURES \\\n" + entries("{{ {gfx}, kanto_{name}_nsbtx }},") + "\n"
        "#define KANTO_OBJECT_EVENT_GFX_MODEL_ANIMS \\\n" + entries("{{ {gfx}, BILLBOARD_MODEL_GENERIC_32x32, BILLBOARD_FRAME_SEQ_GENERIC_WALK, sWalkBillboardAnims }},") + "\n"
        "#define KANTO_OBJECT_EVENT_GFX_RENDER_DETAILS \\\n" + entries("{{ {gfx}, MODEL_TYPE_BILLBOARD, .hasShadow = TRUE, TRACK_TYPE_FOOTSTEPS, .hasReflection = TRUE }},") + "\n")

    mapping = {s: OBJECT_EQUIVALENTS.get(s) for s in OBJECT_EQUIVALENTS}
    mapping.update({f"SPRITE_{n.upper()}": GFX_PREFIX + n.upper() for n in imported})
    (Path(__file__).parent / "kanto_sprites.json").write_text(json.dumps(mapping, indent=2) + "\n")
    print(f"{len(imported)} NPC sprites")
    for sprite, why in skipped:
        print(f"  skipped {sprite}: {why}")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss)
    ids = mmodel_ids(hg)
    import_npcs(hg, ids)
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
