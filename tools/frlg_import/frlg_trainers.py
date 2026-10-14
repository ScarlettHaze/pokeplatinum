"""Convert FRLG trainers (pokefirered src/data/trainers.h and trainer_parties.h)
to Platinum trainer files.

Every trainer needs a defeated flag, and Platinum's flags end where its
trainers do, so FRLG's trainers take the slots of Platinum's unused dummy
trainers (TRAINER_DUMMY_*) in generated/trainers.txt, in the order TRAINERS
lists them. A converted trainer is TRAINER_FRLG_<FRLG name without
TRAINER_>, in res/trainers/data/frlg_<name>.json.

Their lines come from the map's text: <Map>_Text_<Name>Intro, ...Defeat and
...PostBattle, or the labels TRAINERS names.
"""
import json
import re
from pathlib import Path

import frlg_text

PL = Path(__file__).resolve().parents[2]
TRAINERS_TXT = PL / "generated/trainers.txt"
DATA = PL / "res/trainers/data"
PREFIX = "TRAINER_FRLG_"

# FRLG trainer class -> Platinum's.
CLASSES = {
    "TRAINER_CLASS_BUG_CATCHER": "TRAINER_CLASS_BUG_CATCHER",
    "TRAINER_CLASS_YOUNGSTER": "TRAINER_CLASS_YOUNGSTER",
    "TRAINER_CLASS_LASS": "TRAINER_CLASS_LASS",
    "TRAINER_CLASS_RIVAL_EARLY": "TRAINER_CLASS_RIVAL",
    "TRAINER_CLASS_RIVAL_LATE": "TRAINER_CLASS_RIVAL",
    "TRAINER_CLASS_CAMPER": "TRAINER_CLASS_CAMPER",
    "TRAINER_CLASS_HIKER": "TRAINER_CLASS_HIKER",
}
# Gym Leaders and the like have a class of their own (frlg_classes.py).
LEADER_CLASSES = {
    "TRAINER_LEADER_BROCK": "TRAINER_CLASS_KANTO_LEADER_BROCK",
}

# FRLG trainer -> (map whose text has its lines, {message type: label} or None
# for <Map>_Text_<Name>Intro/Defeat/PostBattle).
TRAINERS = {
    "TRAINER_RIVAL_ROUTE22_EARLY_SQUIRTLE": ("Route22", {"TRMSG_DEFEAT": "Route22_Text_EarlyRivalDefeat"}),
    "TRAINER_RIVAL_ROUTE22_EARLY_BULBASAUR": ("Route22", {"TRMSG_DEFEAT": "Route22_Text_EarlyRivalDefeat"}),
    "TRAINER_RIVAL_ROUTE22_EARLY_CHARMANDER": ("Route22", {"TRMSG_DEFEAT": "Route22_Text_EarlyRivalDefeat"}),
    "TRAINER_BUG_CATCHER_RICK": ("ViridianForest", None),
    "TRAINER_BUG_CATCHER_DOUG": ("ViridianForest", None),
    "TRAINER_BUG_CATCHER_SAMMY": ("ViridianForest", None),
    "TRAINER_BUG_CATCHER_ANTHONY": ("ViridianForest", None),
    "TRAINER_BUG_CATCHER_CHARLIE": ("ViridianForest", None),
    "TRAINER_CAMPER_LIAM": ("PewterCity_Gym", None),
    # A Gym Leader's intro and the rest of the defeat speech are in the Gym's
    # script, out of battle.
    "TRAINER_LEADER_BROCK": ("PewterCity_Gym", {"TRMSG_DEFEAT": "PewterCity_Gym_Text_BrockDefeatInBattle"}),
}


def platinum_name(frlg):
    return PREFIX + frlg.removeprefix("TRAINER_")


def read_trainers(fr):
    text = (Path(fr) / "src/data/trainers.h").read_text()
    out = {}
    for m in re.finditer(r"\[(TRAINER_\w+)\]\s*=\s*\{(.*?)\n    \},", text, re.S):
        body = m.group(2)
        field = lambda f: (re.search(r"\." + f + r"\s*=\s*([^\n]*?),?\n", body) or [None, None])[1]
        party = re.search(r"\.party\s*=\s*(\w+)\((\w+)\)", body)
        out[m.group(1)] = {
            "class": field("trainerClass"),
            "name": (re.search(r'\.trainerName\s*=\s*_\("([^"]*)"\)', body) or [None, ""])[1],
            "double": field("doubleBattle") == "TRUE",
            "party": party.group(2) if party else None,
        }
    return out


def read_parties(fr):
    text = (Path(fr) / "src/data/trainer_parties.h").read_text()
    out = {}
    for m in re.finditer(r"(sParty_\w+)\[\]\s*=\s*\{(.*?)\};", text, re.S):
        mons = []
        for mon in re.findall(r"\{(.*?)\n    \}", m.group(2), re.S):
            get = lambda f: (re.search(r"\." + f + r"\s*=\s*([^,\n]+)", mon) or [None, None])[1]
            moves = re.search(r"\.moves\s*=\s*\{([^}]*)\}", mon)
            mons.append({
                "species": get("species"),
                "level": int(get("lvl")),
                "iv": int(get("iv") or 0),
                "item": get("heldItem"),
                "moves": [x.strip() for x in moves.group(1).split(",") if x.strip() != "MOVE_NONE"] if moves else None,
            })
        out[m.group(1)] = mons
    return out


def messages(fr, map_name, trainer, labels):
    texts = frlg_text.map_messages(fr, map_name)
    if labels is None:
        who = trainer["name"].capitalize()
        labels = {"TRMSG_PRE_BATTLE": f"{map_name}_Text_{who}Intro",
                  "TRMSG_DEFEAT": f"{map_name}_Text_{who}Defeat",
                  "TRMSG_POST_BATTLE": f"{map_name}_Text_{who}PostBattle"}
    out = []
    for kind, label in labels.items():
        lines = frlg_text.convert_string(texts[label])
        out.append({"type": kind, "en_US": lines if isinstance(lines, list) else [lines]})
    return out


def convert(fr, frlg, trainers, parties):
    t = trainers[frlg]
    smart = t["class"].startswith("TRAINER_CLASS_RIVAL") or frlg in LEADER_CLASSES
    map_name, labels = TRAINERS[frlg]
    return {
        "name": t["name"].capitalize(),
        "class": LEADER_CLASSES.get(frlg) or CLASSES[t["class"]],
        "items": [],
        "ai_flags": ["AI_FLAG_BASIC", "AI_FLAG_EVAL_ATTACK"] if smart else ["AI_FLAG_BASIC"],
        "double_battle": t["double"],
        "party": [{
            "species": mon["species"],
            "form": 0,
            "level": mon["level"],
            "item": mon["item"],
            "moves": mon["moves"],
            "iv_scale": mon["iv"],
            "ball_seal": 0,
        } for mon in parties[t["party"]]],
        "messages": messages(fr, map_name, t, labels),
    }


def referenced_dummies(lines):
    """Dummy trainers something refers to, such as a rematch table."""
    dummies = {l for l in lines if l.startswith("TRAINER_DUMMY_")}
    out = {d for d in dummies if any(l.startswith(d + "_") for l in lines)}
    for d in ("src", "include", "res/field"):
        for path in (PL / d).rglob("*"):
            if path.suffix in (".c", ".h", ".s", ".json"):
                out |= dummies & set(re.findall(r"TRAINER_DUMMY_\w+", path.read_text(errors="ignore")))
    return out


def import_trainers(fr):
    trainers, parties = read_trainers(fr), read_parties(fr)
    lines = TRAINERS_TXT.read_text().splitlines()
    # Give back the slots of an earlier run, then take the first free dummies.
    for path in DATA.glob("frlg_*.json"):
        path.unlink()
    skip = referenced_dummies(lines)
    taken = [i for i, l in enumerate(lines) if l.startswith(PREFIX)]
    free = sorted(taken + [i for i, l in enumerate(lines) if l.startswith("TRAINER_DUMMY_") and l not in skip])
    for frlg, slot in zip(TRAINERS, free):
        old = lines[slot]
        if old.startswith("TRAINER_DUMMY_"):
            (DATA / (old.removeprefix("TRAINER_").lower() + ".json")).unlink(missing_ok=True)
        lines[slot] = platinum_name(frlg)
        data = convert(fr, frlg, trainers, parties)
        (DATA / (platinum_name(frlg).removeprefix("TRAINER_").lower() + ".json")).write_text(
            json.dumps(data, indent=4, ensure_ascii=False) + "\n")
    TRAINERS_TXT.write_text("\n".join(lines) + "\n")
