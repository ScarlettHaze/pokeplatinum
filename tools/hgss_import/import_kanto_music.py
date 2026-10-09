#!/usr/bin/env python3
"""Give the Kanto map headers HGSS's music.

The sound archive is HGSS's (hgss_sound.py), so the songs need no importing:
this sets each Kanto map header's day and night music to the HGSS song HGSS
plays there, by its HGSS name. Code that picks songs itself (Surf, the
bicycle, battles) uses include/data/kanto_sound.h.

Run after import_kanto_world.py. Usage:
tools/hgss_import/import_kanto_music.py <path-to-pokeheartgold>
"""
import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from hgss_headers import load_headers  # noqa: E402

PL = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss)
    kanto = [h for h in load_headers(hg) if h["regionNo"] == "MAP_REGION_KANTO"]

    headers = PL / "include/data/kanto_map_headers.h"
    text = headers.read_text()
    for h in kanto:
        entry_start = text.index(f"    [MAP_HEADER_KANTO_{h['name'].removeprefix('MAP_')}] = {{")
        entry_end = text.index("    },", entry_start)
        entry = text[entry_start:entry_end]
        entry = re.sub(r"\.dayMusicID = \w+,", f".dayMusicID = {h['dayMusicId']}_sseq,", entry)
        entry = re.sub(r"\.nightMusicID = \w+,", f".nightMusicID = {h['nightMusicId']}_sseq,", entry)
        text = text[:entry_start] + entry + text[entry_end:]
    headers.write_text(text)
    print(f"{len(kanto)} map headers")


if __name__ == "__main__":
    main()
