#!/usr/bin/env python3
"""Put FRLG's events on HGSS's Kanto maps.

Run after tools/hgss_import (which leaves the Kanto maps with warps only):

    tools/frlg_import/import_frlg.py <path-to-pokefirered> <path-to-pokeheartgold>

It brings in the HGSS trainer classes FRLG's trainers need (frlg_classes.py)
and FRLG's trainers (frlg_trainers.py). For each map in MAPS below this
- converts the FRLG map's text to res/text/frlg_<map>.json (frlg_text.py),
- writes the NPCs, signs and triggers into the map's events file, keeping
  its warps,
- points the map header at the map's scripts and text bank.

The scripts themselves (res/field/scripts/scripts_frlg_*.s) are written by
hand from FRLG's: FRLG's maps are laid out differently from HGSS's, so every
walk and every trigger had to be fitted to HGSS's map. Events name their
script by label; the label's place in the file's ScriptEntry list gives the
number the events file needs.

A number in place of a label is a shared script's ID (CUT_TREE for a Cut
tree, an item ball's), and a trainer's script is the trainer. Coordinates are the events file's: overworld maps use world coordinates
(Pallet Town's top left tile is 352, 352), indoor maps their own.
"""
import json
import re
import sys
from pathlib import Path

import frlg_classes
import frlg_text
import frlg_trainers

PL = Path(__file__).resolve().parents[2]
EVENTS = PL / "res/field/events"
SCRIPTS = PL / "res/field/scripts"
HEADERS = PL / "include/data/kanto_map_headers.h"


CUT_TREE = 10000
ROCK_SMASH = 10001
VISIBLE_ITEMS = 7000


def visible_item_script(item):
    """The first of Platinum's item ball scripts that gives one of item."""
    text = (PL / "res/field/scripts/scripts_visible_items.s").read_text()
    labels = re.findall(r"^\s*ScriptEntry\s+(\w+)\s*$", text, re.M)
    for i, label in enumerate(labels):
        body = re.search(r"^" + label + r":\n(.*?)\n\n", text, re.M | re.S)
        if body and f"VAR_0x8008, {item}\n" in body.group(1) + "\n" and "VAR_0x8009, 1\n" in body.group(1) + "\n":
            return VISIBLE_ITEMS + i
    raise KeyError(f"no item ball script gives one {item}")


def item_ball(name, item, x, z, flag):
    return obj(f"LOCALID_ITEM_{name}", "OBJ_EVENT_GFX_POKEBALL", x, z, visible_item_script(item), flag=flag)


def trainer(name, gfx, x, z, frlg, move, dir, sight):
    o = obj(name, gfx, x, z, frlg_trainers.platinum_name(frlg), move, dir=dir)
    o["trainer_type"] = "TRAINER_TYPE_NORMAL"
    o["data"] = [sight]
    return o


def cut_tree(n, x, z):
    return obj(f"LOCALID_CUT_TREE_{n}", "OBJ_EVENT_GFX_CUT_TREE", x, z, CUT_TREE,
               flag=f"FLAG_MAP_LOCAL_HIDE_OBSTACLE_{n}")


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
    "ViridianCity": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN",
        "events": "kanto_events_047_t02",
        "init": True,
        "objects": [
            # FRLG's old man who blocks the road north, then shows how to
            # catch Pokémon. OnTransition moves him off the road.
            obj("LOCALID_TUTORIAL_MAN", "OBJ_EVENT_GFX_KANTO_GSOLDMAN1", 355, 236, "ViridianCity_TutorialOldMan",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_WOMAN", "OBJ_EVENT_GFX_KANTO_GSWOMAN3", 358, 238, "ViridianCity_Woman",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
            # By the Gym, as HGSS's old men.
            obj("LOCALID_OLD_MAN", "OBJ_EVENT_GFX_KANTO_GSOLDMAN1", 375, 240, "ViridianCity_OldMan",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY1", 355, 255, "ViridianCity_Youngster",
                "MOVEMENT_TYPE_WANDER_NORTH_AND_SOUTH", rz=1),
            obj("LOCALID_BOY", "OBJ_EVENT_GFX_KANTO_GSBOY2", 365, 260, "ViridianCity_Boy",
                "MOVEMENT_TYPE_WANDER_AROUND", rx=1, rz=1),
            cut_tree(1, 347, 235),
            cut_tree(2, 342, 261),
        ],
        "bgs": [
            bg(352, 256, "ViridianCity_CitySign", "BG_EVENT_DIR_ALL"),
            bg(357, 230, "ViridianCity_TrainerTips1", "BG_EVENT_DIR_ALL"),
            bg(369, 239, "ViridianCity_GymSign", "BG_EVENT_DIR_ALL"),
            bg(366, 254, "ViridianCity_TrainerTips2", "BG_EVENT_DIR_ALL"),
        ],
        # Row 236 holds every way north (x 336, 349, 353-356 and 360).
        "coords": [
            coord(349, 236, "ViridianCity_RoadBlocked", "VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN", 0, width=12),
            coord(336, 236, "ViridianCity_RoadBlocked", "VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN", 0),
            coord(349, 236, "ViridianCity_TutorialTrigger", "VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN", 1, width=12),
            coord(336, 236, "ViridianCity_TutorialTrigger", "VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN", 1),
            coord(373, 240, "ViridianCity_GymDoorLocked", "VAR_MAP_SCENE_VIRIDIAN_CITY_GYM_DOOR", 0),
        ],
    },
    "ViridianCity_Mart": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN_POKEMART",
        "events": "kanto_events_452_t02fs0101",
        "init": True,
        "objects": [
            obj("LOCALID_CLERK", "OBJ_EVENT_GFX_KANTO_SHOPM1_2", 2, 6, "ViridianCity_Mart_Clerk",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_WOMAN", "OBJ_EVENT_GFX_KANTO_GSWOMAN1", 10, 4, "ViridianCity_Mart_Woman",
                "MOVEMENT_TYPE_WANDER_WEST_AND_EAST", dir=2, rx=1),
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY1", 7, 9, "ViridianCity_Mart_Youngster",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
        ],
    },
    "ViridianCity_PokemonCenter_1F": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN_POKECENTER_1F",
        "events": "kanto_events_453_t02pc0101",
        "objects": [
            obj("LOCALID_NURSE", "OBJ_EVENT_GFX_POKECENTER_NURSE", 8, 11, "ViridianCity_PokemonCenter_1F_Nurse",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_GENTLEMAN", "OBJ_EVENT_GFX_KANTO_GSGENTLEMAN", 14, 13, "ViridianCity_PokemonCenter_1F_Gentleman",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_BOY", "OBJ_EVENT_GFX_KANTO_GSBOY1", 4, 17, "ViridianCity_PokemonCenter_1F_Boy",
                "MOVEMENT_TYPE_LOOK_AROUND"),
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY2", 6, 13, "ViridianCity_PokemonCenter_1F_Youngster",
                "MOVEMENT_TYPE_WANDER_AROUND", rx=1, rz=1),
        ],
    },
    "ViridianCity_House": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN_NORTHEAST_HOUSE",
        "events": "kanto_events_449_t02r0201",
        "objects": [
            obj("LOCALID_BALDING_MAN", "OBJ_EVENT_GFX_KANTO_GSMIDDLEMAN1", 5, 6, "ViridianCity_House_BaldingMan",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_LITTLE_GIRL", "OBJ_EVENT_GFX_KANTO_GSGIRL1", 8, 6, "ViridianCity_House_LittleGirl",
                "MOVEMENT_TYPE_WANDER_NORTH_AND_SOUTH", dir=0, rz=1),
            obj("LOCALID_SPEARY", "OBJ_EVENT_GFX_KANTO_FOLLOWER_MON_STATIC_SPEAROW", 6, 3, "ViridianCity_House_Speary",
                "MOVEMENT_TYPE_WANDER_WEST_AND_EAST", rx=1),
        ],
    },
    # FRLG's Trainer school is HGSS's Trainer House.
    "ViridianCity_School": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN_TRAINER_HOUSE_1F",
        "events": "kanto_events_450_t02r0301",
        "shared": ["PokemonJournal_Text_SpecialFeatureProfOak"],
        "objects": [
            obj("LOCALID_WOMAN", "OBJ_EVENT_GFX_KANTO_GSWOMAN3", 10, 4, "ViridianCity_School_Woman",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_LASS", "OBJ_EVENT_GFX_KANTO_GSGIRL1", 7, 10, "ViridianCity_School_Lass",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
        "bgs": [
            bg(7, 9, "ViridianCity_School_Notebook"),
            bg(6, 2, "ViridianCity_School_Blackboard"),
            bg(8, 2, "ViridianCity_School_PokemonJournal"),
        ],
    },
    # The rival waits out of sight below the way in from Viridian, rows 266 to
    # 268, the three tiles tall FRLG's triggers span.
    "Route22": {
        "header": "MAP_HEADER_KANTO_ROUTE_22",
        "events": "kanto_events_024_r22",
        "objects": [
            obj("LOCALID_RIVAL", "OBJ_EVENT_GFX_KANTO_GSLEADER16", 316, 270, "Route22_Rival",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3, flag="FLAG_HIDE_ROUTE_22_RIVAL"),
        ],
        "bgs": [bg(266, 264, "Route22_LeagueGateSign", "BG_EVENT_DIR_ALL")],
        "coords": [
            coord(319, 266, "Route22_EarlyRivalTrigger", "VAR_MAP_SCENE_ROUTE22", 1, length=3),
        ],
    },
    "Route2": {
        "header": "MAP_HEADER_KANTO_ROUTE_2",
        "events": "kanto_events_007_r02",
        "objects": [
            item_ball("ETHER", "ITEM_ETHER", 373, 212, "FLAG_HIDE_ROUTE2_ETHER"),
            item_ball("PARALYZE_HEAL", "ITEM_PARLYZ_HEAL", 366, 210, "FLAG_HIDE_ROUTE2_PARALYZE_HEAL"),
            cut_tree(1, 369, 218),
            cut_tree(2, 369, 210),
            cut_tree(3, 369, 200),
        ],
        "bgs": [bg(357, 218, "Route2_RouteSign", "BG_EVENT_DIR_ALL")],
    },
    # HGSS's forest has five bug catchers along the path (not trainers in
    # HGSS): FRLG's five, from the south entrance north.
    "ViridianForest": {
        "header": "MAP_HEADER_KANTO_VIRIDIAN_FOREST",
        "events": "kanto_events_143_d46r0101",
        "objects": [
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY1", 25, 71, "ViridianForest_Youngster",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
            obj("LOCALID_BOY", "OBJ_EVENT_GFX_KANTO_GSBOY2", 46, 70, "ViridianForest_Boy",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            trainer("LOCALID_RICK", "OBJ_EVENT_GFX_KANTO_GSBOY3", 48, 73, "TRAINER_BUG_CATCHER_RICK",
                    "MOVEMENT_TYPE_LOOK_WEST", 2, 5),
            trainer("LOCALID_DOUG", "OBJ_EVENT_GFX_KANTO_GSBOY3", 47, 54, "TRAINER_BUG_CATCHER_DOUG",
                    "MOVEMENT_TYPE_LOOK_SOUTH", 1, 4),
            trainer("LOCALID_SAMMY", "OBJ_EVENT_GFX_KANTO_GSBOY3", 47, 39, "TRAINER_BUG_CATCHER_SAMMY",
                    "MOVEMENT_TYPE_LOOK_EAST", 3, 4),
            trainer("LOCALID_ANTHONY", "OBJ_EVENT_GFX_KANTO_GSBOY3", 37, 17, "TRAINER_BUG_CATCHER_ANTHONY",
                    "MOVEMENT_TYPE_LOOK_SOUTH", 1, 1),
            trainer("LOCALID_CHARLIE", "OBJ_EVENT_GFX_KANTO_GSBOY3", 14, 28, "TRAINER_BUG_CATCHER_CHARLIE",
                    "MOVEMENT_TYPE_LOOK_EAST", 3, 1),
            item_ball("POTION_2", "ITEM_POTION", 50, 60, "FLAG_HIDE_VIRIDIAN_FOREST_POTION_2"),
            item_ball("POTION", "ITEM_POTION", 20, 49, "FLAG_HIDE_VIRIDIAN_FOREST_POTION"),
            item_ball("ANTIDOTE", "ITEM_ANTIDOTE", 42, 32, "FLAG_HIDE_VIRIDIAN_FOREST_ANTIDOTE"),
            item_ball("POKE_BALL", "ITEM_POKE_BALL", 23, 17, "FLAG_HIDE_VIRIDIAN_FOREST_POKE_BALL"),
            cut_tree(1, 23, 70),
            cut_tree(2, 42, 70),
        ],
    },
    "PewterCity": {
        "header": "MAP_HEADER_KANTO_PEWTER",
        "events": "kanto_events_048_t03",
        "init": True,
        "objects": [
            obj("LOCALID_LASS", "OBJ_EVENT_GFX_KANTO_GSGIRL1", 384, 89, "PewterCity_Lass",
                "MOVEMENT_TYPE_WANDER_AROUND", rx=1, rz=1),
            obj("LOCALID_MUSEUM_GUIDE", "OBJ_EVENT_GFX_KANTO_GSMIDDLEMAN1", 375, 85, "PewterCity_MuseumGuide",
                "MOVEMENT_TYPE_LOOK_AROUND"),
            obj("LOCALID_FAT_MAN", "OBJ_EVENT_GFX_KANTO_GSBIGMAN", 397, 94, "PewterCity_FatMan",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_BUG_CATCHER", "OBJ_EVENT_GFX_KANTO_GSBOY3", 378, 111, "PewterCity_BugCatcher",
                "MOVEMENT_TYPE_WANDER_WEST_AND_EAST", rx=1),
            # By the way out to Route 3 (x 404, rows 102 to 105).
            obj("LOCALID_GYM_GUIDE", "OBJ_EVENT_GFX_KANTO_GSBOY1", 403, 101, "PewterCity_GymGuide",
                "MOVEMENT_TYPE_LOOK_SOUTH", flag="FLAG_HIDE_PEWTER_CITY_GYM_GUIDE"),
            obj("LOCALID_AIDE", "OBJ_EVENT_GFX_KANTO_ASSISTANTM", 405, 101, "PewterCity_RunningShoesAide",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2, flag="FLAG_HIDE_PEWTER_CITY_RUNNING_SHOES_GUY"),
            obj("LOCALID_ROCK_SMASH_1", "OBJ_EVENT_GFX_ROCK_SMASH", 363, 75, ROCK_SMASH,
                flag="FLAG_MAP_LOCAL_HIDE_OBSTACLE_1"),
        ],
        "bgs": [
            bg(392, 105, "PewterCity_CitySign", "BG_EVENT_DIR_ALL"),
            bg(373, 95, "PewterCity_GymSign", "BG_EVENT_DIR_ALL"),
            bg(379, 81, "PewterCity_MuseumSign", "BG_EVENT_DIR_ALL"),
            bg(373, 112, "PewterCity_TrainerTips", "BG_EVENT_DIR_ALL"),
        ],
        "coords": [
            coord(404, 102, "PewterCity_GymGuideTrigger", "VAR_MAP_SCENE_PEWTER_CITY", 0, length=4),
            coord(404, 102, "PewterCity_RunningShoesAideTrigger", "VAR_MAP_SCENE_PEWTER_CITY", 1, length=4),
        ],
    },
    "PewterCity_Gym": {
        "header": "MAP_HEADER_KANTO_PEWTER_GYM",
        "events": "kanto_events_426_t03gym0101",
        "objects": [
            obj("LOCALID_BROCK", "OBJ_EVENT_GFX_KANTO_GSLEADER14", 7, 4, "PewterCity_Gym_Brock",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            trainer("LOCALID_LIAM", "OBJ_EVENT_GFX_KANTO_CAMPBOY_2", 6, 20, "TRAINER_CAMPER_LIAM",
                    "MOVEMENT_TYPE_LOOK_EAST", 3, 4),
            obj("LOCALID_GYM_GUY", "OBJ_EVENT_GFX_KANTO_SUNGLASSES", 11, 25, "PewterCity_Gym_GymGuy",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
        ],
        "bgs": [bg(4, 25, "PewterCity_Gym_GymStatue"), bg(10, 25, "PewterCity_Gym_GymStatue")],
    },
    "PewterCity_Mart": {
        "header": "MAP_HEADER_KANTO_PEWTER_POKEMART",
        "events": "kanto_events_427_t03fs0101",
        "objects": [
            obj("LOCALID_CLERK", "OBJ_EVENT_GFX_KANTO_SHOPM1_2", 2, 6, "PewterCity_Mart_Clerk",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY1", 6, 9, "PewterCity_Mart_Youngster",
                "MOVEMENT_TYPE_WANDER_NORTH_AND_SOUTH", rz=1),
            obj("LOCALID_BOY", "OBJ_EVENT_GFX_KANTO_GSMAN1", 10, 9, "PewterCity_Mart_Boy",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
        ],
    },
    "PewterCity_PokemonCenter_1F": {
        "header": "MAP_HEADER_KANTO_PEWTER_POKECENTER_1F",
        "events": "kanto_events_428_t03pc0101",
        "objects": [
            obj("LOCALID_NURSE", "OBJ_EVENT_GFX_POKECENTER_NURSE", 8, 11, "PewterCity_PokemonCenter_1F_Nurse",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_GENTLEMAN", "OBJ_EVENT_GFX_KANTO_GSGENTLEMAN", 4, 17, "PewterCity_PokemonCenter_1F_Gentleman",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_JIGGLYPUFF", "OBJ_EVENT_GFX_KANTO_FOLLOWER_MON_STATIC_JIGGLYPUFF", 5, 13,
                "PewterCity_PokemonCenter_1F_Jigglypuff", "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_YOUNGSTER", "OBJ_EVENT_GFX_KANTO_GSBOY1", 6, 13, "PewterCity_PokemonCenter_1F_Youngster",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_KID_1", "OBJ_EVENT_GFX_KANTO_GSBOY2", 10, 15, "PewterCity_PokemonCenter_1F_Kid1",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_KID_2", "OBJ_EVENT_GFX_KANTO_GSBOY1", 11, 15, "PewterCity_PokemonCenter_1F_Kid2",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
        ],
    },
    # FRLG's House1 (the Nidoran's) is HGSS's northeast house, House2 its
    # southwest one.
    "PewterCity_House1": {
        "header": "MAP_HEADER_KANTO_PEWTER_NORTHEAST_HOUSE",
        "events": "kanto_events_425_t03r0201",
        "objects": [
            obj("LOCALID_NIDORAN", "OBJ_EVENT_GFX_KANTO_FOLLOWER_MON_STATIC_NIDORAN_M", 3, 5,
                "PewterCity_House1_Nidoran", "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_LITTLE_BOY", "OBJ_EVENT_GFX_KANTO_GSBABYBOY1", 4, 5, "PewterCity_House1_LittleBoy",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            obj("LOCALID_BALDING_MAN", "OBJ_EVENT_GFX_KANTO_GSMIDDLEMAN1", 8, 7, "PewterCity_House1_BaldingMan",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
    },
    "PewterCity_House2": {
        "header": "MAP_HEADER_KANTO_PEWTER_SOUTHWEST_HOUSE",
        "events": "kanto_events_430_t03r0601",
        "objects": [
            obj("LOCALID_OLD_MAN", "OBJ_EVENT_GFX_KANTO_GSOLDMAN1", 8, 5, "PewterCity_House2_OldMan",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            obj("LOCALID_LITTLE_BOY", "OBJ_EVENT_GFX_KANTO_GSBABYBOY1", 2, 7, "PewterCity_House2_LittleBoy",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
    },
    # HGSS's Museum is one floor: FRLG's 2F people and exhibits join 1F's.
    "PewterCity_Museum_1F": {
        "header": "MAP_HEADER_KANTO_PEWTER_MUSEUM_OF_SCIENCE",
        "events": "kanto_events_424_t03r0101",
        "objects": [
            obj("LOCALID_RECEPTIONIST", "OBJ_EVENT_GFX_KANTO_GSWOMAN6", 12, 15, "PewterCity_Museum_1F_Receptionist",
                "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            obj("LOCALID_OLD_MAN", "OBJ_EVENT_GFX_KANTO_GSOLDMAN1", 6, 5, "PewterCity_Museum_1F_OldMan",
                "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_OLD_AMBER_SCIENTIST", "OBJ_EVENT_GFX_KANTO_GSASSISTANTM", 26, 9,
                "PewterCity_Museum_1F_OldAmberScientist", "MOVEMENT_TYPE_LOOK_WEST", dir=2),
            obj("LOCALID_SCIENTIST", "OBJ_EVENT_GFX_KANTO_GSASSISTANTM", 4, 13, "PewterCity_Museum_1F_Scientist2",
                "MOVEMENT_TYPE_WANDER_AROUND", rx=1, rz=1),
            obj("LOCALID_SPACE_SCIENTIST", "OBJ_EVENT_GFX_KANTO_GSASSISTANTM", 16, 4,
                "PewterCity_Museum_2F_Scientist", "MOVEMENT_TYPE_LOOK_SOUTH"),
            obj("LOCALID_MAN", "OBJ_EVENT_GFX_KANTO_MANIA", 17, 8, "PewterCity_Museum_2F_Man",
                "MOVEMENT_TYPE_WANDER_NORTH_AND_SOUTH", rz=1),
            obj("LOCALID_OLD_MAN_2", "OBJ_EVENT_GFX_KANTO_GSMIDDLEMAN1", 8, 8, "PewterCity_Museum_2F_OldMan",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
            obj("LOCALID_LITTLE_GIRL", "OBJ_EVENT_GFX_KANTO_GSGIRL1", 23, 7, "PewterCity_Museum_2F_LittleGirl",
                "MOVEMENT_TYPE_LOOK_EAST", dir=3),
            obj("LOCALID_BALDING_MAN", "OBJ_EVENT_GFX_KANTO_GSMAN1", 24, 8, "PewterCity_Museum_2F_BaldingMan",
                "MOVEMENT_TYPE_LOOK_NORTH", dir=0),
        ],
        "bgs": [bg(x, z, "PewterCity_Museum_1F_AerodactylFossil", "BG_EVENT_DIR_ALL")
                for x, z in ((9, 8), (10, 8), (11, 8), (9, 9), (10, 9), (11, 9))]
        + [bg(x, z, "PewterCity_Museum_1F_KabutopsFossil", "BG_EVENT_DIR_ALL")
           for x, z in ((15, 6), (15, 7), (15, 8), (13, 6), (14, 6))]
        + [bg(x, 3, "PewterCity_Museum_2F_MoonStone", "BG_EVENT_DIR_ALL") for x in (14, 15, 16, 17)]
        + [bg(x, z, "PewterCity_Museum_2F_SpaceShuttle", "BG_EVENT_DIR_ALL")
           for x, z in ((3, 3), (4, 3), (5, 3), (6, 3), (1, 7), (2, 7))]
        + [bg(x, z, "PewterCity_Museum_1F_PokemonJournalBrock", "BG_EVENT_DIR_ALL")
           for x, z in ((24, 5), (25, 5), (26, 5), (27, 5), (1, 11), (2, 11))],
        "coords": [coord(10, 16, "PewterCity_Museum_1F_EntranceTrigger", "VAR_MAP_SCENE_PEWTER_CITY_MUSEUM_1F", 0)],
        "shared": ["PokemonJournal_Text_SpecialFeatureBrock"],
        "merge": ["PewterCity_Museum_2F"],
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
            if isinstance(e["script"], int) or e["script"].startswith("TRAINER_"):  # a shared script or a trainer
                out.append(e)
                continue
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
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    fr = Path(sys.argv[1])
    frlg_classes.import_classes(Path(sys.argv[2]))
    frlg_trainers.import_trainers(fr)
    frlg_text.import_text(fr, {m: (spec.get("shared", []), spec.get("merge", [])) for m, spec in MAPS.items()})
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
