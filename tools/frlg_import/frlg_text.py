"""Convert FRLG map text (pokefirered data/maps/<Map>/text.inc) to Platinum
text banks.

Each FRLG map becomes res/text/frlg_<map>.json, TEXT_BANK_FRLG_<MAP> in
generated/text_banks.txt. Message IDs stay FRLG's labels
(PalletTown_Text_OakDontGoOut), so the hand-written scripts read like FRLG's.

The words stay FRLG's. The spelling follows the DS games: POKéMON is Pokémon,
OAK is Oak, and straight quotes are curly. Placeholders become string
buffers, which the scripts fill the same way everywhere:

    {PLAYER}     buffer 0, BufferPlayerName 0
    {RIVAL}      buffer 1, BufferRivalName 1
    {STR_VAR_1}  buffer 2
    {STR_VAR_2}  buffer 3
"""
import json
import re
import zlib
from pathlib import Path

PL = Path(__file__).resolve().parents[2]
TEXT = PL / "res/text"
TEXT_BANKS = PL / "generated/text_banks.txt"
PREFIX = "TEXT_BANK_FRLG_"

PLACEHOLDERS = {
    "PLAYER": "{STRVAR_1 3, 0, 0}",
    "RIVAL": "{STRVAR_1 3, 1, 0}",
    "STR_VAR_1": "{STRVAR_1 1, 2, 0}",
    "STR_VAR_2": "{STRVAR_1 1, 3, 0}",
}
# Capitalised words that stay that way on the DS.
KEEP_CAPS = {"PC", "TV", "HP", "PP", "TM", "HM", "KO", "NES", "SNES", "OK", "HQ", "SE", "TMS", "HMS"}


def snake(name):
    """PalletTown_ProfessorOaksLab -> pallet_town_professor_oaks_lab"""
    return re.sub(r"(?<=[a-z])(?=[A-Z])", "_", name).lower()


def bank_name(map_name):
    return "frlg_" + snake(map_name)


def bank_const(map_name):
    return PREFIX + snake(map_name).upper()


def respell(text):
    """POKéMON -> Pokémon, OAK -> Oak; leaves placeholders alone."""
    def word(m):
        w = m.group(0)
        if w.rstrip(".") in KEEP_CAPS or len(w.rstrip(".")) < 2:
            return w
        return w[0] + w[1:].lower()
    parts = re.split(r"(\{[^}]*\})", text)
    for i in range(0, len(parts), 2):
        parts[i] = re.sub(r"(?<![A-Za-z])[A-Zé]*[A-Z][A-Zé]*\.?(?![a-z])", word, parts[i])
        parts[i] = re.sub(r"(?<=[a-z])'S(?![A-Za-z])", "'s", parts[i]).replace("'", "’")
        parts[i] = re.sub(r'"([^"]*)"', r"“\1”", parts[i])
    return "".join(parts)


def convert_string(raw):
    """One FRLG message (the .string pieces joined) -> Platinum's JSON lines."""
    raw = raw.removesuffix("$")
    raw = re.sub(r"\{(?:COLOR|FONT|HIGHLIGHT|SHADOW)[^}]*\}", "", raw)
    raw = re.sub(r"\{(\w+)\}", lambda m: PLACEHOLDERS.get(m.group(1), m.group(0)), raw)
    # FRLG: \n next line, \l scroll a line, \p new page.
    # Platinum: \n next line, \f scroll a line, \r new page.
    raw = raw.replace("\\n", "\n").replace("\\l", "\f").replace("\\p", "\r")
    raw = respell(raw)
    lines = re.findall(r"[^\n\r\f]*[\n\r\f]|[^\n\r\f]+$", raw)
    return lines[0] if len(lines) == 1 else lines or ""


def parse_text_inc(path):
    """-> [(label, raw string)] in file order."""
    messages, label, pieces = [], None, []
    for line in path.read_text().splitlines():
        m = re.match(r"^(\w+)::", line)
        if m:
            if label:
                messages.append((label, "".join(pieces)))
            label, pieces = m.group(1), []
            continue
        m = re.match(r'\s*\.string\s+"(.*)"\s*$', line)
        if m and label:
            pieces.append(m.group(1))
    if label:
        messages.append((label, "".join(pieces)))
    return messages


def convert_map(fr, map_name, extra=()):
    """FRLG map's messages, plus (label, raw) pairs from shared text files."""
    rows = [{"id": label, "en_US": convert_string(raw)}
            for label, raw in parse_text_inc(Path(fr) / "data/maps" / map_name / "text.inc") + list(extra)]
    return {"key": zlib.crc32(bank_name(map_name).encode()) & 0xFFFF, "messages": rows}


def shared_messages(fr, labels):
    """Pick messages by label from pokefirered's shared text (data/text/*.inc, data/event_scripts.s)."""
    found = {}
    for path in sorted((Path(fr) / "data/text").glob("*.inc")) + [Path(fr) / "data/event_scripts.s"]:
        for label, raw in parse_text_inc(path):
            if label in labels:
                found[label] = raw
    missing = set(labels) - set(found)
    assert not missing, f"not in shared text: {sorted(missing)}"
    return [(label, found[label]) for label in labels]


def import_text(fr, maps):
    """maps: {map name: [shared labels]}. Writes the banks and lists them in text_banks.txt."""
    for old in TEXT.glob("frlg_*.json"):
        old.unlink()
    for map_name, shared in maps.items():
        data = convert_map(fr, map_name, shared_messages(fr, shared))
        (TEXT / f"{bank_name(map_name)}.json").write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    lines = [l for l in TEXT_BANKS.read_text().splitlines() if not l.startswith(PREFIX)]
    TEXT_BANKS.write_text("\n".join(lines + [bank_const(m) for m in maps]) + "\n")
    return {m: bank_const(m) for m in maps}
