#!/usr/bin/env python3
"""Turn Rowan's new game intro into HGSS's Professor Oak one.

Both intros come from the same code and their NARCs lay the professor and
player pictures out the same way (same tilemap, 4bpp, 128 tiles), so HGSS's
Oak, Ethan and Lyra pictures replace Rowan, Lucas and Dawn. The text that
names Rowan or Sinnoh is changed to HGSS's wording.

Usage: tools/hgss_import/import_kanto_intro.py <path-to-pokeheartgold>
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from narc import read_narc, write_narc  # noqa: E402

PL = Path(__file__).resolve().parents[2]
BASE = Path(__file__).parent / "base"

# Platinum intro.narc member -> HGSS demo/intro member (see sBgPicNCGR_NCLR in
# pokeheartgold's oaks_speech.c and RowanIntro_LoadTilemap in Platinum's).
PICTURES = {
    19: "intro_00000010.NCGR",  # Rowan -> Oak
    20: "intro_00000011.NCLR",
    9: "intro_00000012.NCGR",  # Lucas -> Ethan
    10: "intro_00000013.NCGR",
    11: "intro_00000014.NCGR",
    12: "intro_00000015.NCGR",
    13: "intro_00000016.NCLR",
    14: "intro_00000017.NCGR",  # Dawn -> Lyra
    15: "intro_00000018.NCGR",
    16: "intro_00000019.NCGR",
    17: "intro_00000020.NCGR",
    18: "intro_00000021.NCLR",
}

TEXT = {
    "res/text/rowan_intro.json": {
        "RowanIntro_Text_MyNameRowan": [
            ("My name is Rowan.\r", "My name is Oak.\r"),
            ("However, everyone just calls me\n", "People affectionately refer to me\n"),
            ("the Pokémon Professor.\r", "as the Pokémon Professor.\r"),
        ],
    },
    "res/text/rowan_intro_tv_app.json": {
        "RowanIntroTv_TextId": [
            ("That was the comment left by Prof. Rowan,\n", "That was the comment left by Prof. Oak,\n"),
            ("who has returned to Sinnoh from the\n", "who has returned to Kanto from the\n"),
            ("Kanto region.", "Johto region."),
        ],
    },
}


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss) / "files/demo/intro/intro"

    members = read_narc(BASE / "intro.narc")
    for index, name in PICTURES.items():
        members[index] = (hg / name).read_bytes()
    (PL / "res/prebuilt/demo/intro/intro.narc").write_bytes(write_narc(members))

    for path, edits in TEXT.items():
        bank = json.loads((PL / path).read_text())
        for msg in bank["messages"]:
            for old, new in edits.get(msg["id"], []):
                lines = msg["en_US"]
                if old in lines:
                    lines[lines.index(old)] = new
                else:
                    assert new in lines, (path, msg["id"], old)
        (PL / path).write_text(json.dumps(bank, indent=2, ensure_ascii=False) + "\n")


if __name__ == "__main__":
    main()
