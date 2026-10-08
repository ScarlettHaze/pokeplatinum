#!/usr/bin/env python3
"""Import the music of HGSS's Kanto maps into Platinum's sound archive.

Each HGSS song plays instruments from HGSS's basic wave archive, which differs
from Platinum's (both games keep their own resident in the sound heap, and
there is no room for both). So each song gets its own copy of its bank whose
instruments play from a compact wave archive holding only the samples the
song selects: SEQ_KANTO_<song>, BANK_KANTO_<song> and WAVE_ARC_KANTO_<song>.
Instruments the song never selects play the archive's first sample.

The songs are written to res/sound/kanto/ and listed in pl_sound_data.json;
the Kanto map headers then use them. SOUND_SYSTEM_HEAP_SIZE leaves room for
the largest one.

Run after import_kanto_world.py. Usage:
tools/hgss_import/import_kanto_music.py <path-to-pokeheartgold>
"""
import argparse
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import sdat  # noqa: E402
from hgss_headers import load_headers  # noqa: E402

PL = Path(__file__).resolve().parents[2]
SOUND = PL / "res/sound"
OUT = SOUND / "kanto"
PREFIX = "KANTO_"


def kanto_name(hgss_seq):
    return "SEQ_" + PREFIX + hgss_seq.removeprefix("SEQ_")


def compact_bank(seq, bank, wavarcs):
    """Copy of bank whose instruments play from one wave archive of the samples seq uses."""
    data = bytearray(bank["file"])
    used = {}
    samples = []
    for program in sorted(sdat.sseq_programs(seq["file"])):
        for ref in sdat.sbnk_instrument_note_defs(data, program):
            swav, slot = struct.unpack_from("<HH", data, ref)
            key = (slot, swav)
            if key not in used:
                used[key] = len(samples)
                samples.append(sdat.swar_samples(wavarcs[bank["waves"][slot]]["file"])[swav])
    for ref in sdat.sbnk_note_defs(data):
        swav, slot = struct.unpack_from("<HH", data, ref)
        struct.pack_into("<HH", data, ref, used.get((slot, swav), 0), 0)
    # The bank's wave archive references are filled in by the sound archive builder.
    return bytes(data), sdat.build_swar(samples or [sdat.swar_samples(wavarcs[bank["waves"][0]]["file"])[0]])


def json_entry(fields):
    body = ",\n".join(f'\t\t\t"{k}":\t{v}' for k, v in fields.items())
    return "\t\t}, {\n" + body + "\n"


def update_sound_json(seqs, banks, wavarcs):
    path = SOUND / "pl_sound_data.json"
    text = path.read_text()
    # Drop a previous import.
    text = re.sub(r'\t\t\}, \{\n\t\t\t"name":\t"(SEQ|BANK|WAVE_ARC)_' + PREFIX + r'[^{}]*?\n(?=\t\t\})', "", text)
    for key, entries in (("seqInfo", seqs), ("bankInfo", banks), ("wavarcInfo", wavarcs)):
        start = text.index(f'"{key}":')
        end = text.index("\t\t}]", start)
        text = text[:end] + "".join(json_entry(e) for e in entries) + text[end:]
    path.write_text(text)


# Platinum's music players get channels 0 to 10; HGSS's get 1 to 10, 13 and
# 15 (0xA7FE). HGSS's songs need the extra square wave (13) and noise (15)
# channels, which play their PSG and drum parts.
MUSIC_PLAYER_CHANNELS = {"PLAYER_FIELD": 0xA7FE, "PLAYER_ME": 0xA7FE, "PLAYER_BGM": 0xA7FE}


def update_player_channels():
    path = SOUND / "pl_sound_data.json"
    text = path.read_text()
    for player, channels in MUSIC_PLAYER_CHANNELS.items():
        text, count = re.subn(r'("name":\t"' + player + r'",\n\t\t\t"maxSequences":\t\d+,\n\t\t\t"channels":\t)\d+',
                              lambda m: m.group(1) + str(channels), text)
        assert count == 1, player
    path.write_text(text)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    hg = Path(parser.parse_args().hgss)
    archive = sdat.read((hg / "files/data/sound/gs_sound_data.sdat").read_bytes())
    by_name = {s["name"]: s for s in archive["seqs"] if s}

    kanto = [h for h in load_headers(hg) if h["regionNo"] == "MAP_REGION_KANTO"]
    songs = sorted({h["dayMusicId"] for h in kanto} | {h["nightMusicId"] for h in kanto})

    OUT.mkdir(exist_ok=True)
    for old in OUT.glob("*"):
        if old.suffix in (".sseq", ".sbnk", ".swar"):
            old.unlink()
    seqs, banks, wavarcs, files = [], [], [], []
    largest = 0
    for song in songs:
        seq = by_name[song]
        name = kanto_name(song).removeprefix("SEQ_")
        bank, swar = compact_bank(seq, archive["banks"][seq["bank"]], archive["wavarcs"])
        largest = max(largest, len(swar) + len(bank) + len(seq["file"]))
        for filename, data in ((f"SEQ_{name}.sseq", seq["file"]), (f"BANK_{name}.sbnk", bank), (f"WAVE_ARC_{name}.swar", swar)):
            (OUT / filename).write_bytes(data)
            files.append(filename)
        player = archive["players"][seq["player"]]
        if f'"name":\t"{player}"' not in (SOUND / "pl_sound_data.json").read_text():
            player = "PLAYER_FIELD"
        seqs.append({"name": f'"SEQ_{name}"', "fileName": f'"SEQ_{name}.sseq"', "bank": f'"BANK_{name}"',
                     "volume": seq["volume"], "channelPriority": seq["channelPriority"],
                     "playerPriority": seq["playerPriority"], "player": f'"{player}"'})
        banks.append({"name": f'"BANK_{name}"', "fileName": f'"BANK_{name}.sbnk"',
                      "waves": f'["WAVE_ARC_{name}", "", "", ""]'})
        wavarcs.append({"name": f'"WAVE_ARC_{name}"', "fileName": f'"WAVE_ARC_{name}.swar"'})
    update_sound_json(seqs, banks, wavarcs)
    update_player_channels()

    # The banks are consecutive in the archive; sound.c accepts them as field BGM banks.
    bank_names = [b["name"].strip('"') for b in banks]
    (PL / "include/data/kanto_sound.h").write_text(
        "// Generated by tools/hgss_import/import_kanto_music.py, do not edit.\n"
        "#ifndef POKEPLATINUM_DATA_KANTO_SOUND_H\n#define POKEPLATINUM_DATA_KANTO_SOUND_H\n\n"
        f"#define KANTO_BGM_BANK_FIRST {bank_names[0]}_sbnk\n"
        f"#define KANTO_BGM_BANK_LAST  {bank_names[-1]}_sbnk\n\n#endif\n")

    (OUT / "meson.build").write_text(
        "# Generated by tools/hgss_import/import_kanto_music.py, do not edit.\n"
        "kanto_sound_files = files(\n" + "".join(f"    '{f}',\n" for f in files) + ")\n")

    # Use the songs in the Kanto map headers.
    headers = PL / "include/data/kanto_map_headers.h"
    text = headers.read_text()
    for h in kanto:
        entry_start = text.index(f"    [MAP_HEADER_KANTO_{h['name'].removeprefix('MAP_')}] = {{")
        entry_end = text.index("    },", entry_start)
        entry = text[entry_start:entry_end]
        entry = re.sub(r"\.dayMusicID = \w+,", f".dayMusicID = {kanto_name(h['dayMusicId'])}_sseq,", entry)
        entry = re.sub(r"\.nightMusicID = \w+,", f".nightMusicID = {kanto_name(h['nightMusicId'])}_sseq,", entry)
        text = text[:entry_start] + entry + text[entry_end:]
    headers.write_text(text)
    print(f"{len(songs)} songs, largest {largest // 1024} KB loaded")


if __name__ == "__main__":
    main()
