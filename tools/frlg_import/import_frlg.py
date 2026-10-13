#!/usr/bin/env python3
"""Put FRLG's events on HGSS's Kanto maps.

Run after tools/hgss_import (which leaves the Kanto maps with warps only):

    tools/frlg_import/import_frlg.py <path-to-pokefirered>

For each map in MAPS below this
- converts the FRLG map's text to res/text/frlg_<map>.json (frlg_text.py),
- writes the NPCs, signs and triggers into the map's events file, keeping
  its warps,
- points the map header at the map's scripts and text bank.

The scripts themselves (res/field/scripts/scripts_frlg_*.s) are written by
hand from FRLG's: FRLG's maps are laid out differently from HGSS's, so every
walk and every trigger had to be fitted to HGSS's map. Events name their
script by label; the label's place in the file's ScriptEntry list gives the
number the events file needs.

Coordinates are the events file's: overworld maps use world coordinates
(Pallet Town's top left tile is 352, 352), indoor maps their own.
"""
import json
import re
import sys
from pathlib import Path

import frlg_text

PL = Path(__file__).resolve().parents[2]
EVENTS = PL / "res/field/events"
SCRIPTS = PL / "res/field/scripts"
HEADERS = PL / "include/data/kanto_map_headers.h"


def obj(id, gfx, x, z, script, move="MOVEMENT_TYPE_NONE", dir=1, flag="0", rx=0, rz=0):
    return {"id": id, "graphics_id": gfx, "movement_type": move, "trainer_type": "TRAINER_TYPE_NONE",
            "hidden_flag": flag, "script": script, "initial_dir": dir, "data": [],
            "movement_range_x": rx, "movement_range_z": rz, "x": x, "z": z, "y": 0}


def bg(x, z, script, facing="BG_EVENT_DIR_NORTH"):
    return {"script": script, "type": 0, "x": x, "z": z, "y": 0, "player_facing_dir": facing}


def coord(x, z, script, var, value, width=1, length=1):
    return {"script": script, "x": x, "z": z, "y": 0, "width": width, "length": length, "var": var, "value": value}


# initial_dir: 0 north, 1 south, 2 west, 3 east.
MAPS = {
    "PalletTown": {
        "header": "MAP_HEADER_KANTO_PALLET",
        "events": "kanto_events_046_t01",
        "objects": [
            obj("LOCALID_SIGN_LADY", "OBJ_EVENT_GFX_KANTO_GSWOMAN1", 362, 367, "PalletTown_SignLady",
                "MOVEMENT_TYPE_WANDER_WEST_AND_EAST", dir=2, rx=1),
            obj("LOCALID_FAT_MAN", "OBJ_EVENT_GFX_KANTO_GSBIGMAN", 372, 380, "PalletTown_FatMan",
                "MOVEMENT_TYPE_LOOK_AROUND"),
            # Waits out of sight below the town's north exit for the player.
            obj("LOCALID_PROF_OAK", "OBJ_EVENT_GFX_KANTO_OOKIDO", 367, 363, "PalletTown_ProfOak",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0, flag="FLAG_HIDE_OAK_IN_PALLET_TOWN"),
        ],
        "bgs": [
            bg(364, 369, "PalletTown_TownSign", "BG_EVENT_DIR_ALL"),
            bg(359, 363, "PalletTown_PlayersHouseSign", "BG_EVENT_DIR_ALL"),
            bg(370, 363, "PalletTown_RivalsHouseSign", "BG_EVENT_DIR_ALL"),
            bg(373, 378, "PalletTown_OakPokemonResearchLabSign", "BG_EVENT_DIR_ALL"),
        ],
        # The four tiles of the way out to Route 1.
        "coords": [
            coord(366, 355, "PalletTown_OakTrigger", "VAR_MAP_SCENE_PALLET_TOWN_OAK", 0, width=4),
        ],
    },
    "PalletTown_PlayersHouse_1F": {
        "header": "MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F",
        "events": "kanto_events_455_t01r0101",
        "objects": [
            obj("LOCALID_MOM", "OBJ_EVENT_GFX_KANTO_REDMAMA", 6, 6, "PalletTown_PlayersHouse_1F_Mom",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
        "bgs": [
            bg(5, 3, "PalletTown_PlayersHouse_1F_TV"),
            bg(6, 3, "PalletTown_PlayersHouse_1F_TV"),
        ],
    },
    "PalletTown_PlayersHouse_2F": {
        "header": "MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_2F",
        "events": "kanto_events_458_t01r0102",
        # The PC beside it is HGSS's, which its tile already makes work.
        "bgs": [bg(5, 3, "PalletTown_PlayersHouse_2F_NES")],
    },
    "PalletTown_RivalsHouse": {
        "header": "MAP_HEADER_KANTO_PALLET_TOWN_BLUES_HOUSE_1F",
        "events": "kanto_events_456_t01r0201",
        "objects": [
            obj("LOCALID_DAISY", "OBJ_EVENT_GFX_KANTO_NANAMI", 6, 6, "PalletTown_RivalsHouse_Daisy",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
        ],
    },
    "PalletTown_ProfessorOaksLab": {
        "header": "MAP_HEADER_KANTO_PALLET_TOWN_OAKS_LAB",
        "events": "kanto_events_457_t01r0301",
        "init": True,
        "shared": ["Text_GiveNicknameToThisMon", "Text_Bookshelf"],
        "objects": [
            obj("LOCALID_PROF_OAK", "OBJ_EVENT_GFX_KANTO_OOKIDO", 8, 6, "PalletTown_ProfessorOaksLab_ProfOak",
                "MOVEMENT_TYPE_LOOK_SOUTH", flag="FLAG_HIDE_OAK_IN_HIS_LAB"),
            obj("LOCALID_RIVAL", "OBJ_EVENT_GFX_KANTO_GSLEADER16", 7, 7, "PalletTown_ProfessorOaksLab_Rival",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0, flag="FLAG_HIDE_RIVAL_IN_LAB"),
            # On the desk, left to right as in FRLG. Objects on the desk can't
            # be talked to, so the desk tiles below them are signs (as in HGSS).
            obj("LOCALID_BULBASAUR_BALL", "OBJ_EVENT_GFX_POKEBALL", 7, 3, "PalletTown_ProfessorOaksLab_PokeBallObject",
                flag="FLAG_HIDE_BULBASAUR_BALL"),
            obj("LOCALID_SQUIRTLE_BALL", "OBJ_EVENT_GFX_POKEBALL", 8, 3, "PalletTown_ProfessorOaksLab_PokeBallObject",
                flag="FLAG_HIDE_SQUIRTLE_BALL"),
            obj("LOCALID_CHARMANDER_BALL", "OBJ_EVENT_GFX_POKEBALL", 9, 3, "PalletTown_ProfessorOaksLab_PokeBallObject",
                flag="FLAG_HIDE_CHARMANDER_BALL"),
            obj("LOCALID_AIDE_1", "OBJ_EVENT_GFX_KANTO_ASSISTANTM", 2, 12, "PalletTown_ProfessorOaksLab_Aide1",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_AIDE_2", "OBJ_EVENT_GFX_KANTO_ASSISTANTM", 11, 8, "PalletTown_ProfessorOaksLab_Aide2",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            obj("LOCALID_AIDE_3", "OBJ_EVENT_GFX_KANTO_ASSISTANTM", 12, 12, "PalletTown_ProfessorOaksLab_Aide3",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
        "bgs": [bg(7, 3, "PalletTown_ProfessorOaksLab_BulbasaurBall"),
                bg(8, 3, "PalletTown_ProfessorOaksLab_SquirtleBall"),
                bg(9, 3, "PalletTown_ProfessorOaksLab_CharmanderBall"),
                bg(5, 3, "PalletTown_ProfessorOaksLab_Computer")]
        + [bg(x, z, "PalletTown_ProfessorOaksLab_Bookshelf")
           for z, xs in ((3, (11, 12, 13, 14)), (11, (1, 2, 3, 4, 11, 12, 13, 14))) for x in xs],
        # Rows 9 to 11 are the only way to the door.
        "coords": [
            coord(5, 9, "PalletTown_ProfessorOaksLab_LeaveStarterSceneTrigger",
                  "VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB", 2, width=6),
            coord(5, 9, "PalletTown_ProfessorOaksLab_RivalBattleTrigger",
                  "VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB", 3, width=6),
        ],
    },
    "Route1": {
        "header": "MAP_HEADER_KANTO_ROUTE_1",
        "events": "kanto_events_006_r01",
        "objects": [
            obj("LOCALID_MART_CLERK", "OBJ_EVENT_GFX_KANTO_SHOPM1_2", 370, 340, "Route1_MartClerk",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_BOY", "OBJ_EVENT_GFX_KANTO_GSBOY1", 365, 325, "Route1_Boy",
                "MOVEMENT_TYPE_WANDER_NORTH_AND_SOUTH", rz=1),
        ],
        "bgs": [bg(365, 338, "Route1_RouteSign", "BG_EVENT_DIR_ALL")],
    },
}


def script_file(map_name, init=False):
    return ("scripts_init_frlg_" if init else "scripts_frlg_") + frlg_text.snake(map_name)


def script_ids(map_name):
    """{label: number} from the ScriptEntry list of the map's script file."""
    text = (SCRIPTS / f"{script_file(map_name)}.s").read_text()
    labels = re.findall(r"^\s*ScriptEntry\s+(\w+)\s*$", text, re.M)
    return {label: i + 1 for i, label in enumerate(labels)}


def write_events(map_name, spec):
    ids = script_ids(map_name)

    def resolve(events):
        out = []
        for e in events:
            e = dict(e)
            assert e["script"] in ids, f"{map_name}: {e['script']} is not a ScriptEntry"
            e["script"] = ids[e["script"]]
            out.append(e)
        return out

    path = EVENTS / f"{spec['events']}.json"
    events = json.loads(path.read_text())
    events["object_events"] = resolve(spec.get("objects", []))
    events["bg_events"] = resolve(spec.get("bgs", []))
    events["coord_events"] = resolve(spec.get("coords", []))
    path.write_text(json.dumps(events, indent=4) + "\n")


def patch_header(map_name, spec):
    text = HEADERS.read_text()
    start = text.index(f"    [{spec['header']}] = {{\n")
    end = text.index("    },\n", start)
    entry = text[start:end]
    entry = re.sub(r"\.scriptsArchiveID = \w+,", f".scriptsArchiveID = {script_file(map_name)},", entry)
    init = script_file(map_name, init=True) if spec.get("init") else "scripts_init_empty"
    entry = re.sub(r"\.initScriptsArchiveID = \w+,", f".initScriptsArchiveID = {init},", entry)
    entry = re.sub(r"\.msgArchiveID = \w+,", f".msgArchiveID = {frlg_text.bank_const(map_name)},", entry)
    HEADERS.write_text(text[:start] + entry + text[end:])


def register_scripts(names):
    """List the script files in res/field/scripts' meson.build and scripts.order."""
    meson = SCRIPTS / "meson.build"
    lines = [l for l in meson.read_text().splitlines() if "'scripts_frlg_" not in l and "'scripts_init_frlg_" not in l]
    last = max(i for i, l in enumerate(lines) if re.match(r"^\s*'[^']+\.s',\s*$", l))
    lines[last + 1:last + 1] = [f"    '{n}.s'," for n in names]
    meson.write_text("\n".join(lines) + "\n")
    order = SCRIPTS / "scripts.order"
    lines = [l for l in order.read_text().splitlines() if not l.startswith(("scripts_frlg_", "scripts_init_frlg_"))]
    order.write_text("\n".join(lines + names) + "\n")


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    fr = Path(sys.argv[1])
    frlg_text.import_text(fr, {m: spec.get("shared", []) for m, spec in MAPS.items()})
    names = []
    for map_name, spec in MAPS.items():
        write_events(map_name, spec)
        patch_header(map_name, spec)
        names.append(script_file(map_name))
        if spec.get("init"):
            names.append(script_file(map_name, init=True))
    register_scripts(names)


if __name__ == "__main__":
    main()
