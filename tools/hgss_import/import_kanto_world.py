#!/usr/bin/env python3
"""Make Kanto (imported by import_kanto.py) the overworld, replacing Sinnoh.

Stage B: map matrices, map headers, warps and location names.

- map_matrix_000 (the main overworld matrix) becomes HGSS's Kanto block.
- Every HGSS matrix used by a Kanto map is imported as kanto_map_matrix_*.
- Every Kanto map gets a MAP_HEADER_KANTO_* header (include/data/kanto_map_headers.h)
  and an events file holding its warps. Warps into maps that were not imported
  (Johto) are moved off the map so the warp IDs of the others stay valid.
- HGSS location names past Platinum's are appended so that mapLabelTextID uses
  HGSS's map section numbers unchanged.

Run import_kanto.py first. Usage: tools/hgss_import/import_kanto_world.py <path-to-pokeheartgold>
"""
import argparse
import glob
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from hgss_headers import load_headers  # noqa: E402
from hgss_matrix import decode_matrix  # noqa: E402
from import_kanto import KANTO_WORLD_X, KANTO_WORLD_Y, matrix_key  # noqa: E402
from meson_lists import update_enum_list, update_meson_files, update_order  # noqa: E402

PL = Path(__file__).resolve().parents[2]
MAPPING = Path(__file__).parent / "kanto_mapping.json"

BLOCK = 32
WORLD_OFFSET_X = KANTO_WORLD_X.start * BLOCK
WORLD_OFFSET_Z = KANTO_WORLD_Y.start * BLOCK
HEADER_PREFIX = "MAP_HEADER_KANTO_"
WARP_DISABLED = 0xFFFF
HGSS_WARP_DYNAMIC = 4095

MAP_TYPE = {
    "MAP_TYPE_CITY_TOWN": "MAP_TYPE_TOWN_CITY",
    "MAP_TYPE_ROUTE": "MAP_TYPE_OUTDOORS",
    "MAP_TYPE_CAVE": "MAP_TYPE_CAVE",
    "MAP_TYPE_INTERIOR": "MAP_TYPE_INDOORS",
}

MAP_LABEL_WINDOW = {
    "MAP_TYPE_TOWN_CITY": "MAP_LABEL_WINDOW_CITY",
    "MAP_TYPE_OUTDOORS": "MAP_LABEL_WINDOW_ROUTE",
    "MAP_TYPE_CAVE": "MAP_LABEL_WINDOW_CAVE",
    "MAP_TYPE_INDOORS": "MAP_LABEL_WINDOW_INDOORS",
    "MAP_TYPE_POKECENTER": "MAP_LABEL_WINDOW_INDOORS",
}

BATTLE_BG = {
    "BATTLE_BG_GENERAL": "BACKGROUND_PLAIN",
    "BATTLE_BG_CITY": "BACKGROUND_CITY",
    "BATTLE_BG_FOREST": "BACKGROUND_FOREST",
    "BATTLE_BG_MOUNTAIN": "BACKGROUND_MOUNTAIN",
    "BATTLE_BG_OCEAN": "BACKGROUND_WATER",
    "BATTLE_BG_BUILDING_1": "BACKGROUND_INDOORS_1",
    "BATTLE_BG_BUILDING_2": "BACKGROUND_INDOORS_2",
    "BATTLE_BG_CAVE_1": "BACKGROUND_CAVE_1",
    "BATTLE_BG_CAVE_2": "BACKGROUND_CAVE_2",
    "BATTLE_BG_CAVE_3": "BACKGROUND_CAVE_3",
    "BATTLE_BG_WILL": "BACKGROUND_AARON",
    "BATTLE_BG_KOGA": "BACKGROUND_BERTHA",
    "BATTLE_BG_BRUNO": "BACKGROUND_FLINT",
    "BATTLE_BG_KAREN": "BACKGROUND_LUCIAN",
    "BATTLE_BG_LANCE": "BACKGROUND_CYNTHIA",
}

# HGSS weather IDs that differ from Platinum's.
WEATHER = {"0": "OVERWORLD_WEATHER_CLEAR", "11": "OVERWORLD_WEATHER_DARK_FLASH"}

# Platinum has no HGSS music, so Kanto plays the closest Platinum track
# (day, night) until the HGSS sound data is ported.
MUSIC = {
    "SEQ_GS_POKESEN": ("SEQ_PC_01_sseq", "SEQ_PC_02_sseq"),
    "SEQ_GS_FS": ("SEQ_FS_sseq",) * 2,
    "SEQ_GS_GYM": ("SEQ_GYM_sseq",) * 2,
    "SEQ_GS_GAME": ("SEQ_BLD_GAME_sseq",) * 2,
    "SEQ_GS_T_MASARA": ("SEQ_TOWN01_D_sseq", "SEQ_TOWN01_N_sseq"),
    "SEQ_GS_T_CHION": ("SEQ_TOWN07_D_sseq", "SEQ_TOWN07_N_sseq"),
    "SEQ_GS_T_GUREN": ("SEQ_TOWN06_D_sseq", "SEQ_TOWN06_N_sseq"),
    "SEQ_GS_C_TOKIWA": ("SEQ_TOWN02_D_sseq", "SEQ_TOWN02_N_sseq"),
    "SEQ_GS_C_NIBI": ("SEQ_CITY03_D_sseq", "SEQ_CITY03_N_sseq"),
    "SEQ_GS_C_HANADA": ("SEQ_CITY02_D_sseq", "SEQ_CITY02_N_sseq"),
    "SEQ_GS_C_KUCHIBA": ("SEQ_CITY07_D_sseq", "SEQ_CITY07_N_sseq"),
    "SEQ_GS_C_TAMAMUSHI": ("SEQ_CITY05_D_sseq", "SEQ_CITY05_N_sseq"),
    "SEQ_GS_C_YAMABUKI": ("SEQ_CITY01_D_sseq", "SEQ_CITY01_N_sseq"),
    "SEQ_GS_C_SEKICHIKU": ("SEQ_CITY08_D_sseq", "SEQ_CITY08_N_sseq"),
    "SEQ_GS_R_1_26": ("SEQ_ROAD_A_D_sseq", "SEQ_ROAD_A_N_sseq"),
    "SEQ_GS_R_9_03": ("SEQ_ROAD_B_D_sseq", "SEQ_ROAD_B_N_sseq"),
    "SEQ_GS_R_10_03": ("SEQ_ROAD_B_D_sseq", "SEQ_ROAD_B_N_sseq"),
    "SEQ_GS_R_10_11": ("SEQ_ROAD_B_D_sseq", "SEQ_ROAD_B_N_sseq"),
    "SEQ_GS_R_12_03": ("SEQ_ROAD_C_D_sseq", "SEQ_ROAD_C_N_sseq"),
    "SEQ_GS_R_12_24": ("SEQ_ROAD_C_D_sseq", "SEQ_ROAD_C_N_sseq"),
    "SEQ_GS_R_13_03": ("SEQ_ROAD_D_D_sseq", "SEQ_ROAD_D_N_sseq"),
    "SEQ_GS_R_13_11": ("SEQ_ROAD_D_D_sseq", "SEQ_ROAD_D_N_sseq"),
    "SEQ_GS_R_14_03": ("SEQ_ROAD_D_D_sseq", "SEQ_ROAD_D_N_sseq"),
    "SEQ_GS_R_15_03": ("SEQ_ROAD_E_D_sseq", "SEQ_ROAD_E_N_sseq"),
    "SEQ_GS_R_16_03": ("SEQ_ROAD_E_D_sseq", "SEQ_ROAD_E_N_sseq"),
    "SEQ_GS_R_17_01": ("SEQ_ROAD_BZA_D_sseq", "SEQ_ROAD_BZA_N_sseq"),
    "SEQ_GS_R_17_03": ("SEQ_ROAD_BZA_D_sseq", "SEQ_ROAD_BZA_N_sseq"),
    "SEQ_GS_CHAMPROAD": ("SEQ_ROAD_F_D_sseq", "SEQ_ROAD_F_N_sseq"),
    "SEQ_GS_D_IWAYAMA": ("SEQ_D_02_sseq",) * 2,
    "SEQ_GS_OTSUKIMI_EVENT": ("SEQ_D_02_sseq",) * 2,
    "SEQ_GS_D_CHIKATSUURO": ("SEQ_D_01_sseq",) * 2,
    "SEQ_GS_D_KOORINONUKE": ("SEQ_D_03_sseq",) * 2,
    "SEQ_GS_D_CHAMPROAD": ("SEQ_D_LEAGUE_sseq",) * 2,
    "SEQ_GS_D_TOKIWANOMORI3": ("SEQ_D_05_sseq",) * 2,
    "SEQ_GS_SAFARI_FIELD": ("SEQ_D_SAFARI_sseq",) * 2,
    "SEQ_PL_BICYCLE": ("SEQ_ROAD_A_D_sseq", "SEQ_ROAD_A_N_sseq"),
}


def header_name(hgss_name):
    return HEADER_PREFIX + hgss_name.removeprefix("MAP_")


def events_name(bank):
    return "kanto_events_" + bank.removeprefix("NARC_zone_event_").removesuffix("_bin").lower()


def matrix_name(key):
    return "kanto_map_matrix_" + key.lower()


def is_true(value):
    return value.strip() in ("TRUE", "1")


class WorldImporter:
    def __init__(self, hg):
        self.hg = Path(hg)
        self.mapping = json.loads(MAPPING.read_text())
        self.land_names = {int(k): v for k, v in self.mapping["landData"].items()}
        self.area_names = {int(k): v for k, v in self.mapping["areas"].items()}
        headers = load_headers(hg)
        self.by_id = {h["id"]: h for h in headers}
        self.by_name = {h["name"]: h for h in headers}
        self.kanto = [h for h in headers if h["regionNo"] == "MAP_REGION_KANTO"]
        self.kanto_names = {h["name"] for h in self.kanto}

    def matrix(self, key):
        path = self.hg / f"files/fielddata/mapmatrix/map_matrix/map_matrix_{key}.bin"
        return decode_matrix(path.read_bytes())

    def land(self, land_id):
        return "MAP_NONE" if land_id == 0xFFFF else self.land_names[land_id]

    def matrix_header(self, header_id):
        h = self.by_id.get(header_id)
        if h is None or h["name"] not in self.kanto_names:
            return "MAP_HEADER_EVERYWHERE"
        return header_name(h["name"])

    # -------------------------------------------------------------- matrices
    def import_matrices(self):
        world = self.matrix("0000_EVERYWHERE")
        ys, xs = KANTO_WORLD_Y, KANTO_WORLD_X
        main = {
            "name": world["name"],
            "headers": [[self.matrix_header(world["headers"][y][x]) for x in xs] for y in ys],
            "altitudes": [[world["altitudes"][y][x] for x in xs] for y in ys],
            "maps": [[self.land(world["maps"][y][x]) for x in xs] for y in ys],
        }
        self.write_json(PL / "res/field/matrices/map_matrix_000.json", main)

        keys = sorted({matrix_key(h["matrixId"]) for h in self.kanto} - {"0000_EVERYWHERE"})
        names = []
        self.matrix_names = {"0000_EVERYWHERE": "map_matrix_000"}
        for key in keys:
            m = self.matrix(key)
            data = {
                "name": m["name"],
                "headers": [[self.matrix_header(h) for h in row] for row in m["headers"]] if m["headers"] else [],
                "altitudes": m["altitudes"] or [],
                "maps": [[self.land(land) for land in row] for row in m["maps"]],
            }
            name = matrix_name(key)
            self.write_json(PL / "res/field/matrices" / f"{name}.json", data)
            names.append(name)
            self.matrix_names[key] = name
        update_meson_files(PL / "res/field/matrices/meson.build", "json", [f"{n}.json" for n in names])
        update_order(PL / "res/field/matrices/map_matrices.order", names)

    # ---------------------------------------------------------------- events
    def warp_dest(self, warp):
        if warp["header"] == HGSS_WARP_DYNAMIC:
            return "MAP_HEADER_DYNAMIC"
        if warp["header"] in self.kanto_names:
            return header_name(warp["header"])
        return None

    def import_events(self):
        banks = sorted({h["eventsBank"] for h in self.kanto})
        world_banks = {h["eventsBank"] for h in self.kanto if matrix_key(h["matrixId"]) == "0000_EVERYWHERE"}
        names = []
        self.event_names = {}
        self.disabled_warps = []
        for bank in banks:
            src = self.hg / "files/fielddata/eventdata/zone_event" / (bank.removeprefix("NARC_zone_event_").removesuffix("_bin") + ".json")
            events = json.loads(src.read_text())
            dx, dz = (WORLD_OFFSET_X, WORLD_OFFSET_Z) if bank in world_banks else (0, 0)
            warps = []
            for w in events.get("warps", []):
                dest = self.warp_dest(w)
                x, z = w["x"] - dx, w["z"] - dz
                if dest is None:
                    self.disabled_warps.append((bank, w["header"]))
                    dest, x, z = "MAP_HEADER_DYNAMIC", WARP_DISABLED, WARP_DISABLED
                warps.append({"x": x, "z": z, "dest_header_id": dest, "dest_warp_id": w["anchor"]})
            name = events_name(bank)
            # Signs, NPCs and triggers need HGSS's scripts, which are ported separately.
            self.write_json(PL / "res/field/events" / f"{name}.json",
                            {"bg_events": [], "object_events": [], "warp_events": warps, "coord_events": []})
            names.append(name)
            self.event_names[bank] = name
        update_meson_files(PL / "res/field/events/meson.build", "json", [f"{n}.json" for n in names])
        update_order(PL / "res/field/events/zone_event.order", names)

    # --------------------------------------------------------------- headers
    def map_type(self, h):
        if re.search(r"POKECENTER_1F$", h["name"]):
            return "MAP_TYPE_POKECENTER"
        return MAP_TYPE[h["mapType"]]

    def header_entry(self, h):
        map_type = self.map_type(h)
        day, night = MUSIC[h["dayMusicId"]]
        if h["nightMusicId"] != h["dayMusicId"]:
            night = MUSIC[h["nightMusicId"]][1]
        fields = {
            "areaDataArchiveID": self.area_names[int(h["areaDataBank"])],
            "preloadedMapObjectsArchiveID": "0x0",
            "mapMatrixID": self.matrix_names[matrix_key(h["matrixId"])],
            "scriptsArchiveID": "scripts_empty",
            "initScriptsArchiveID": "scripts_init_empty",
            "msgArchiveID": "TEXT_BANK_JUBILIFE_CITY",
            "dayMusicID": day,
            "nightMusicID": night,
            "wildEncountersArchiveID": "ENCOUNTERS_NONE",
            "eventsArchiveID": self.event_names[h["eventsBank"]],
            "mapLabelTextID": self.location_ids[h["mapsec"]],
            "mapLabelWindowID": MAP_LABEL_WINDOW[map_type],
            "weather": WEATHER[h["weather"]],
            "cameraType": f"CAMERA_TYPE_HGSS_{int(h['cameraType']):02}",
            "mapType": map_type,
            "battleBG": BATTLE_BG[h["battleBg"]],
            "isBikeAllowed": "TRUE" if is_true(h["bikeAllowed"]) else "FALSE",
            "isRunningAllowed": "TRUE" if map_type in ("MAP_TYPE_TOWN_CITY", "MAP_TYPE_OUTDOORS", "MAP_TYPE_CAVE") else "FALSE",
            "isEscapeRopeAllowed": "TRUE" if is_true(h["escapeRopeAllowed"]) else "FALSE",
            "isFlyAllowed": "TRUE" if is_true(h["flyAllowed"]) else "FALSE",
        }
        body = "".join(f"        .{k} = {v},\n" for k, v in fields.items())
        return f"    [{header_name(h['name'])}] = {{\n{body}    }},\n"

    def import_headers(self):
        out = ["// Generated by tools/hgss_import/import_kanto_world.py, do not edit.\n",
               "// Included from the middle of sMapHeaders in data/map_headers.h.\n\n"]
        out += [self.header_entry(h) for h in self.kanto]
        (PL / "include/data/kanto_map_headers.h").write_text("".join(out))
        update_enum_list(PL / "generated/map_headers.txt", HEADER_PREFIX,
                         [header_name(h["name"]) for h in self.kanto], before="MAP_HEADER_COUNT")

    # ---------------------------------------------------------------- names
    def import_location_names(self):
        path = PL / "res/text/location_names.json"
        bank = json.loads(path.read_text())
        msgs = [m for m in bank["messages"] if not m["id"].startswith("LocationNames_Text_Kanto")]
        gmm = (self.hg / "files/msgdata/msg/msg_0279.gmm").read_text()
        hgss = re.findall(r'<language name="English">(.*?)</language>', gmm, re.S)
        assert [m["en_US"] for m in msgs] == hgss[:len(msgs)], "Platinum and HGSS location names diverge"
        sec_ids = {}
        for line in (self.hg / "include/constants/map_sections.h").read_text().splitlines():
            m = re.match(r"#define\s+(MAPSEC_\w+)\s+(\d+)", line)
            if m:
                sec_ids[m.group(1)] = int(m.group(2))
        by_index = {}
        for i, text in enumerate(hgss[len(msgs):], len(msgs)):
            word = "".join(p.capitalize() for p in re.sub(r"[^A-Za-z0-9 ]", "", text).split()) or f"Unused{i}"
            ident = f"LocationNames_Text_Kanto{i:03}_{word}"
            msgs.append({"id": ident, "en_US": text})
            by_index[i] = ident
        bank["messages"] = msgs
        path.write_text(json.dumps(bank, indent=2, ensure_ascii=False) + "\n")
        self.location_ids = {}
        for sec, i in sec_ids.items():
            self.location_ids[sec] = by_index.get(i) or msgs[i]["id"]

    @staticmethod
    def write_json(path, data):
        path.write_text(json.dumps(data, indent=4) + "\n")

    def run(self):
        self.import_matrices()
        self.import_events()
        self.import_location_names()
        self.import_headers()
        self.mapping["headers"] = {h["name"]: header_name(h["name"]) for h in self.kanto}
        MAPPING.write_text(json.dumps(self.mapping, indent=2) + "\n")
        print(f"{len(self.kanto)} headers, {len(self.matrix_names)} matrices, {len(self.event_names)} event files")
        for bank, dest in sorted(set(self.disabled_warps)):
            print(f"  disabled warp in {bank} to non-Kanto map {dest}")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    WorldImporter(parser.parse_args().hgss).run()


if __name__ == "__main__":
    main()
