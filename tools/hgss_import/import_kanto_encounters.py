#!/usr/bin/env python3
"""Import the wild encounters of HGSS's Kanto maps.

The tables are converted to Platinum's encounter format. HGSS gives every
grass slot its own morning, day and night species, while Platinum's format
has one species per slot plus day and night species for slots 2 and 3: the
slots take HGSS's morning species, and slots 2 and 3 its day and night ones.

HGSS's Hoenn/Sinnoh radio sound encounters, rock smash encounters and swarms
are not imported: Platinum has no Pokégear radio, rock smash encounters or
Kanto swarms.

Run after import_kanto_world.py, which assigns the encounter files to the headers.
Usage: tools/hgss_import/import_kanto_encounters.py <path-to-pokeheartgold>
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from hgss_headers import load_headers  # noqa: E402
from meson_lists import update_meson_files, update_order  # noqa: E402

PL = Path(__file__).resolve().parents[2]
NONE = "SPECIES_NONE"
# Version exclusives take HeartGold's species.
VERSION = "HEARTGOLD"


def by_version(value):
    return value[VERSION] if isinstance(value, dict) else value


def species(value, time=None):
    """Resolve a slot's species: by time of day, then by version, when they differ."""
    if isinstance(value, dict) and time in value:
        value = value[time]
    return value[VERSION] if isinstance(value, dict) else value


def encounters_name(hgss_map):
    return f"kanto_encounters_{hgss_map.lower()}"


def land(mons, time):
    mons = mons or [{"level": 0, "species": {time: NONE}}] * 12
    return [{"level": by_version(m["level"]), "species": species(m["species"], time)} for m in mons]


def water(table):
    mons = table["mons"] or [{"level": {"min": 0, "max": 0}, "species": NONE}] * 5
    return [{"level_max": by_version(m["level"]["max"]), "level_min": by_version(m["level"]["min"]), "species": species(m["species"])} for m in mons]


def convert(enc):
    morning = land(enc["land"]["mons"], "morn")
    day = [m["species"] for m in land(enc["land"]["mons"], "day")]
    night = [m["species"] for m in land(enc["land"]["mons"], "nite")]
    fishing = enc["fishing"]
    return {
        "land_rate": enc["land"]["rate"],
        "land_encounters": morning,
        "swarms": [NONE] * 2,
        # Platinum swaps only slots 2 and 3 by time of day.
        "day": day[2:4],
        "night": night[2:4],
        "radar": [NONE] * 4,
        "rate_form0": 100,
        "rate_form1": 100,
        "rate_form2": 0,
        "rate_form3": 0,
        "rate_form4": 0,
        "unown_table": 0,
        "ruby": [NONE] * 2,
        "sapphire": [NONE] * 2,
        "emerald": [NONE] * 2,
        "firered": [NONE] * 2,
        "leafgreen": [NONE] * 2,
        "surf_rate": enc["surf"]["rate"],
        "surf_encounters": water(enc["surf"]),
        "old_rod_rate": fishing["old_rod"]["rate"],
        "old_rod_encounters": water(fishing["old_rod"]),
        "good_rod_rate": fishing["good_rod"]["rate"],
        "good_rod_encounters": water(fishing["good_rod"]),
        "super_rod_rate": fishing["super_rod"]["rate"],
        "super_rod_encounters": water(fishing["super_rod"]),
        # Kanto is not on the Pokédex's Sinnoh area map.
        "map_category": {"map_type": "none", "map_number": 0},
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss)

    kanto = [h for h in load_headers(hg) if h["regionNo"] == "MAP_REGION_KANTO"]
    tables = {e["map"]: e for e in json.loads((hg / "files/fielddata/encountdata/gs_enc_data.json").read_text())["encounters"]}

    names = []
    for hgss_map in sorted({h["wildEncounterBank"].removeprefix("ENCDATA_") for h in kanto} - {"NA"}):
        name = encounters_name(hgss_map)
        (PL / "res/field/encounters" / f"{name}.json").write_text(json.dumps(convert(tables[hgss_map]), indent=4) + "\n")
        names.append(name)

    update_meson_files(PL / "res/field/encounters/meson.build", "json", [f"{n}.json" for n in names])
    update_order(PL / "res/field/encounters/encounters.order", names)

    headers = PL / "include/data/kanto_map_headers.h"
    text = headers.read_text()
    for h in kanto:
        bank = h["wildEncounterBank"].removeprefix("ENCDATA_")
        if bank == "NA":
            continue
        name = "MAP_HEADER_KANTO_" + h["name"].removeprefix("MAP_")
        start = text.index(f"    [{name}] = {{")
        end = text.index("    },", start)
        entry = text[start:end].replace(".wildEncountersArchiveID = ENCOUNTERS_NONE,", f".wildEncountersArchiveID = {encounters_name(bank)},")
        text = text[:start] + entry + text[end:]
    headers.write_text(text)
    print(f"{len(names)} encounter tables")


if __name__ == "__main__":
    main()
