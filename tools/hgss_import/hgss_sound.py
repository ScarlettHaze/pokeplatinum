#!/usr/bin/env python3
"""Build Platinum's sound archive from HGSS's.

The ROM's sound archive is HGSS's, unchanged: its music, sound effects, cries
and instruments. Platinum's code names sounds by Platinum's names, so this
writes pl_sound_data.naix with each Platinum name pointing at an HGSS sound:

1. the HGSS sound chosen in HAND below, for Platinum sounds HGSS lacks;
2. the HGSS sound with the Platinum sound's original DP name, as Platinum's
   archive stored it (pl_sound_names.json);
3. the HGSS sound with the same name;
4. the same, with HGSS's SEQ_GS_ or SEQ_ME_ prefix (SEQ_SHINKA is
   SEQ_GS_SHINKA, SEQ_BADGE is SEQ_ME_BADGE).

Platinum names that match nothing and that the code doesn't use point at
HGSS's silent SEQ_DUMMY (or the first bank or wave archive). HGSS's own names
are defined too, for code that plays HGSS sounds by name.

Cries keep their numbers: like Platinum, HGSS's cry wave archives are indexed
by species, with Sky Forme Shaymin at 494.

Usage: hgss_sound.py <gs_sound_data.sdat> <pl_sound_names.json> <out.sdat> <out.naix>
"""
import json
import re
import shutil
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import sdat  # noqa: E402

# Platinum sounds HGSS lacks, by the name Platinum's code uses, and the HGSS
# sound that plays instead. Sinnoh-only places get their closest HGSS song.
HAND = {
    # Battles
    "BATTLE_ARCEUS": "SEQ_GS_VS_KODAI",
    "BATTLE_CYRUS": "SEQ_GS_VS_ROCKET",
    "BATTLE_DIALGA_PALKIA": "SEQ_GS_VS_KODAI",
    "BATTLE_FRONTIER_BRAIN": "SEQ_GS_BA_BRAIN",
    "BATTLE_GALACTIC_CMDR": "SEQ_GS_VS_ROCKET",
    "BATTLE_GALACTIC_GRUNT": "SEQ_GS_VS_ROCKET",
    "BATTLE_GIRATINA": "SEQ_GS_VS_KODAI",
    "BATTLE_LAKE_GUARDIAN": "SEQ_GS_VS_SUICUNE",
    "BATTLE_LEGENDARY": "SEQ_GS_VS_KODAI",
    "BATTLE_REGI_TRIO": "SEQ_GS_VS_KODAI",
    "BATTLE_TRAINER": "SEQ_GS_VS_TRAINER",
    "VICTORY_CYRUS": "SEQ_GS_WIN1",
    "VICTORY_FRONTIER_BRAIN": "SEQ_GS_WINBRAIN",
    "VICTORY_GALACTIC_GRUNT": "SEQ_GS_WIN1",
    # Trainers' eyes-meet music
    "SEQ_EYE_BOY": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_KID": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_FIGHT": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_SPORT": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_MOUNT": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_ELITE": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_FUN": "SEQ_GS_EYE_K_SHOUNEN",
    "SEQ_EYE_GIRL": "SEQ_GS_EYE_K_SHOUJO",
    "SEQ_EYE_LADY": "SEQ_GS_EYE_K_SHOUJO",
    "SEQ_EYE_RICH": "SEQ_GS_EYE_K_SHOUJO",
    "SEQ_EYE_MYS": "SEQ_GS_EYE_K_AYASHII",
    "SEQ_EYE_TENNO": "SEQ_GS_EYE_K_AYASHII",
    "SEQ_EYE_CHAMP": "SEQ_GS_EYE_K_AYASHII",
    "SEQ_EYE_ENKA": "SEQ_GS_EYE_BOUZU",
    "SEQ_EYE_GINGA": "SEQ_GS_EYE_ROCKET",
    # Fanfares
    "SEQ_FANFA1": "SEQ_ME_LVUP",
    "SEQ_FANFA2": "SEQ_ME_ITEM",
    "SEQ_FANFA3": "SEQ_ME_KEYITEM",
    "SEQ_FANFA4": "SEQ_ME_ITEM",
    "SEQ_FANFA5": "SEQ_ME_SHINKAOME",
    "SEQ_POCKETCH": "SEQ_ME_POKEGEAR_REGIST",
    "SEQ_HATANIGE": "SEQ_ME_ITEM",
    "SEQ_KINOMI1": "SEQ_ME_KINOMI",
    "SEQ_SLOT_ATARI": "SEQ_GS_GAMEATARI",
    "SEQ_SLOT_OOATARI": "SEQ_GS_GAMEATARI",
    "SEQ_PL_DON2": "SEQ_ME_ROULETTE",
    "SEQ_PL_POINTGET3": "SEQ_ME_BPGET",
    "SEQ_PL_WINMINI2": "SEQ_ME_MINIGAME",
    # Events and story
    "SEQ_OPENING": "SEQ_GS_STARTING",
    "SEQ_TITLE00": "SEQ_GS_OPENING_TITLE_G",
    "SEQ_KENKYUJO": "SEQ_GS_OHKIDO_RABO",
    "SEQ_THE_BOY": "SEQ_GS_E_SUPPORT_M",
    "SEQ_THE_GIRL": "SEQ_GS_E_SUPPORT_F",
    "SEQ_THE_RIV": "SEQ_GS_E_RIVAL1",
    "SEQ_TSURETEKE": "SEQ_GS_E_TSURETEKE1",
    "SEQ_THE_EVENT02": "SEQ_GS_E_HOUOU",
    "SEQ_THE_EVENT04": "SEQ_GS_E_MINAKI",
    "SEQ_PL_HANDSOME": "SEQ_GS_E_MINAKI",
    "SEQ_PL_EV_GIRA": "SEQ_GS_E_ARCEUS",
    "SEQ_PL_EV_GIRA2": "SEQ_GS_E_ARCEUS",
    "SEQ_FUE": "SEQ_GS_HUE",
    "SEQ_PL_PIANO": "SEQ_GS_RADIO_KOMORIUTA",
    "SEQ_PL_AUDIO": "SEQ_GS_RADIO_MARCH",
    "SEQ_TV_HOUSOU": "SEQ_GS_RADIO_JINGLE",
    "SEQ_TV_END": "SEQ_GS_RADIO_JINGLE",
    "SEQ_BLD_EV_DENDO2": "SEQ_GS_E_DENDOUIRI",
    "SEQ_BLD_DENDO": "SEQ_GS_E_DENDOUIRI",
    "SEQ_BLD_ENDING": "SEQ_GS_ENDING",
    "SEQ_KUSAGASA": "SEQ_GS_SAFARI_FIELD",
    # Buildings, Wi-Fi and the Battle Frontier
    "SEQ_PC_01": "SEQ_GS_POKESEN",
    "SEQ_PC_02": "SEQ_GS_POKESEN",
    "SEQ_BLD_GAME": "SEQ_GS_GAME",
    "SEQ_BLD_TV": "SEQ_GS_KAIDENPA",
    "SEQ_BLD_BLD_GTC": "SEQ_GS_BLD_GTC",
    "SEQ_WIFILOBBY": "SEQ_GS_WIFI_ACCESS",
    "SEQ_PRESENT": "SEQ_GS_WIFI_PRESENT",
    "SEQ_PL_WIFIGAME": "SEQ_GS_WIFIGAME",
    "SEQ_PL_WIFIPARADE": "SEQ_GS_WIFIPARADE",
    "SEQ_PL_WIFITOWER": "SEQ_GS_WIFITOWER",
    "SEQ_PL_WIFIUNION": "SEQ_GS_WIFIUNION",
    "SEQ_PL_GURUGURU": "SEQ_GS_GURUGURU",
    "SEQ_BF_TOWWER": "SEQ_GS_BATTLETOWER",
    "SEQ_PL_FRO": "SEQ_GS_BATTLETOWER2",
    "SEQ_PL_BF_CASTLE": "SEQ_GS_BF_CASTLE",
    "SEQ_PL_BF_CASTLE02": "SEQ_GS_BF_CASTLE",
    "SEQ_PL_BF_FACTORY": "SEQ_GS_BF_FACTORY",
    "SEQ_PL_BF_ROULETTE": "SEQ_GS_BF_ROULETTE",
    "SEQ_PL_BF_STAGE": "SEQ_GS_BF_STAGE",
    # Contests play the Pokéathlon's music
    "CONTEST_DRESSING_ROOM": "SEQ_GS_PT_ENTR",
    "SEQ_CO_DRESS": "SEQ_GS_PT_ENTR",
    "SEQ_BLD_CON": "SEQ_GS_PT_OPEN",
    "SEQ_CO_KEKKA": "SEQ_GS_PT_RESULT",
    "SEQ_CO_FANFA": "SEQ_ME_PT_VICTORY",
    # Sinnoh's places
    "SEQ_PL_TOWN02": "SEQ_GS_T_WAKABA",
    "SEQ_D_AGITO": "SEQ_GS_D_AJITO",
    "SEQ_D_GINLOBBY": "SEQ_GS_D_AJITO",
    "SEQ_D_LAKE": "SEQ_GS_D_SHINTO",
    "SEQ_D_RYAYHY": "SEQ_GS_D_SHINTO",
    "SEQ_PL_D_GIRATINA": "SEQ_GS_D_SHINTO",
    "SEQ_AUS": "SEQ_GS_D_SHINTO",
    "SEQ_D_SAFARI": "SEQ_GS_SAFARI_FIELD",
    "SEQ_D_LEAGUE": "SEQ_GS_D_CHAMPROAD",
    "SEQ_D_MOUNT1": "SEQ_GS_D_IWAYAMA",
    "SEQ_D_MOUNT2": "SEQ_GS_RYUUNOANA",
    "SEQ_TANKOU": "SEQ_GS_D_CHIKATSUURO",
    # Sound effects
    "SE_CONFIRM": "SEQ_SE_DP_SELECT",
    "SEQ_SE_DP_CLIMAX03": "SEQ_SE_DP_CLIMAX01",
    "SEQ_SE_DP_CLIMAX09": "SEQ_SE_DP_CLIMAX10",
    "SEQ_SE_DP_CLIMAX12": "SEQ_SE_DP_CLIMAX15",
    "SEQ_SE_DP_CON_013": "SEQ_SE_DP_CON_015",
    "SEQ_SE_DP_CON_020": "SEQ_SE_DP_CON_021",
    "SEQ_SE_PL_CON_034": "SEQ_SE_DP_CON_034",
    "SEQ_SE_DP_TRAIN02": "SEQ_SE_DP_TRAIN04",
    "SEQ_SE_DP_TRAIN03": "SEQ_SE_DP_TRAIN04",
    "SEQ_SE_PL_FW089B": "SEQ_SE_PL_FW089",
    "SEQ_SE_PL_FW089_2": "SEQ_SE_PL_FW089",
    "SEQ_SE_PL_FW463": "SEQ_SE_DP_FW463",
    "SEQ_SE_PL_W060": "SEQ_SE_DP_W060",
    "SEQ_SE_PL_W082C": "SEQ_SE_DP_W082C",
    "SEQ_SE_PL_W392": "SEQ_SE_DP_W392",
    "SEQ_SE_PL_UG_006": "SEQ_SE_DP_UG_006",
    "SEQ_SE_PL_TOKEI21": "SEQ_SE_PL_TOKEI3",
    "SEQ_SE_PL_YUKI": "SEQ_SE_DP_YUKIASHI",
    "SEQ_SE_PL_JUMP2": "SEQ_SE_DP_DANSA",
    "SEQ_SE_PL_SYUWA": "SEQ_SE_PL_WARP",
    "SEQ_SE_PL_SYUWA2": "SEQ_SE_PL_WARP",
    "SEQ_SE_PL_SYUWA3": "SEQ_SE_PL_WARP",
    "SEQ_SE_PL_GIRA": "SEQ_DUMMY",
    "SEQ_SE_PL_MEKI": "SEQ_DUMMY",
    "SEQ_SE_PL_MEKI2": "SEQ_DUMMY",
    "SEQ_SE_PL_KUSARI": "SEQ_DUMMY",
    "SEQ_SE_PL_GYM01": "SEQ_DUMMY",
    "SEQ_SE_PL_GYM02": "SEQ_DUMMY",
    # Second entries for the same Platinum name, keyed by their full name
    "SEQ_OPENING_sseq_1": "SEQ_GS_STARTING2",
    "SEQ_SE_DP_KATI_sseq_1": "SEQ_SE_DP_KATI",
    # The Great Marsh tram's sounds
    "BANK_SE_TRAIN": "BANK_SE_SHIP",
    "WAVE_ARC_SE_TRAIN": "WAVE_ARC_SE_SHIP",
}
# Sinnoh's towns, cities, routes and caves, which only Sinnoh's map headers
# and system_flags.c name.
for n in list(range(1, 12)):
    for tod in "DN":
        HAND[f"SEQ_CITY{n:02d}_{tod}"] = "SEQ_GS_C_KOGANE"
for n in (1, 2, 3, 6, 7):
    for tod in "DN":
        HAND[f"SEQ_TOWN{n:02d}_{tod}"] = "SEQ_GS_T_WAKABA"
for road in ("A", "B", "BZA", "C", "D", "E", "F", "SNOW"):
    for tod in "DN":
        HAND[f"SEQ_ROAD_{road}_{tod}"] = "SEQ_GS_R_1_29"
for n in range(1, 7):
    HAND[f"SEQ_D_{n:02d}"] = "SEQ_GS_D_CHIKATSUURO"

KINDS = {"sseq": 0, "sbnk": 2, "swar": 3}
DUMMY = {"sseq": "SEQ_DUMMY"}


def symbols(data):
    symb = struct.unpack_from("<I", data, 0x10)[0]
    return {rec: sdat._symbols(data, symb, rec) for rec in range(8)}


def main():
    hgss_sdat, names_json, out_sdat, out_naix = map(Path, sys.argv[1:5])
    data = hgss_sdat.read_bytes()
    syms = symbols(data)
    index = {kind: {n: i for i, n in enumerate(syms[rec]) if n} for kind, rec in KINDS.items()}
    pl = json.loads(names_json.read_text())

    defines = {}
    for name, (_, orig) in pl["files"].items():
        m = re.fullmatch(r"(\w+?)_(sseq|sbnk|swar)(_\d+)?", name)
        base, kind, dup = m.groups()
        target = HAND.get(name) or (HAND.get(base) if not dup else None)
        own = [orig] + ([] if dup else [base])
        prefixed = [c.replace("SEQ_", p, 1) for c in own if c.startswith("SEQ_") for p in ("SEQ_GS_", "SEQ_ME_")]
        for cand in [target] + own + prefixed:
            if cand and cand in index[kind]:
                defines[name] = index[kind][cand]
                break
        else:
            defines[name] = index[kind][DUMMY[kind]] if kind in DUMMY else 0
    for kind, names in index.items():
        for n, i in names.items():
            defines.setdefault(f"{n}_{kind}", i)
    for rec in (4, 5):  # players, groups
        for i, n in enumerate(syms[rec]):
            if n:
                defines.setdefault(n, i)

    guard = "res_sound_pl_sound_data_naix"
    lines = ["/*", f" * Generated by tools/hgss_import/hgss_sound.py from {hgss_sdat.name}.",
             " * DO NOT MODIFY IT; MANUAL EDITS WILL BE LOST", " */", "",
             f"#ifndef {guard}", f"#define {guard}", ""]
    lines += [f"#define {n} {i}" for n, i in defines.items()]
    lines += ["", f"#endif // {guard}", ""]
    out_naix.write_text("\n".join(lines))
    shutil.copyfile(hgss_sdat, out_sdat)


if __name__ == "__main__":
    main()
