"""Convert HGSS message banks (GMM) to Platinum text banks (JSON).

The message IDs stay HGSS's (msg_0446_T01_00000 and so on), so converted
scripts reference them unchanged. Each bank becomes res/text/kanto_<gmm>.json,
TEXT_BANK_KANTO_<GMM> in generated/text_banks.txt.
"""
import json
import re
import xml.etree.ElementTree as ET
import zlib
from pathlib import Path

PL = Path(__file__).resolve().parents[2]
TEXT = PL / "res/text"
TEXT_BANKS = PL / "generated/text_banks.txt"
PREFIX = "TEXT_BANK_KANTO_"


def gmm_name(msg_bank):
    """NARC_msg_msg_0446_T01_bin -> msg_0446_T01"""
    return msg_bank.removeprefix("NARC_msg_").removesuffix("_bin")


def bank_name(gmm):
    return "kanto_" + gmm.lower()


def bank_const(gmm):
    return PREFIX + gmm.upper()


def split_lines(text):
    """HGSS writes \\n, \\r and \\f as escapes; Platinum's JSON keeps one line per entry."""
    text = text.replace("\\n", "\n").replace("\\r", "\r").replace("\\f", "\f")
    lines = re.findall(r"[^\n\r\f]*[\n\r\f]|[^\n\r\f]+$", text)
    return lines[0] if len(lines) == 1 else lines or ""


def convert(gmm_path):
    rows = []
    for row in ET.parse(gmm_path).getroot().iter("row"):
        text = next((l.text or "" for l in row.iter("language") if l.get("name") == "English"), "")
        rows.append({"id": row.get("id"), "en_US": split_lines(text)})
    key = zlib.crc32(gmm_path.name.encode()) & 0xFFFF
    return {"key": key, "messages": rows}


def import_text(hg, gmms):
    """Write the banks and list them in text_banks.txt. Returns {gmm: bank constant}."""
    for old in TEXT.glob("kanto_*.json"):
        old.unlink()
    for gmm in gmms:
        data = convert(hg / "files/msgdata/msg" / f"{gmm}.gmm")
        (TEXT / f"{bank_name(gmm)}.json").write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
    lines = [l for l in TEXT_BANKS.read_text().splitlines() if not l.startswith(PREFIX)]
    TEXT_BANKS.write_text("\n".join(lines + [bank_const(g) for g in gmms]) + "\n")
    return {g: bank_const(g) for g in gmms}
