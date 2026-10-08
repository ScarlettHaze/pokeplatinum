"""Translate HGSS field scripts to Platinum's script commands.

HGSS's script language descends from Platinum's, so most commands have a
Platinum equivalent, often under another name or with other arguments.
Translator.translate_file() turns one HGSS scr_seq file into a Platinum
scripts file. Each script entry (ScrDef) is translated with everything it can
reach; an entry that reaches a command with no Platinum equivalent (Unsupported)
gets a stand-in instead: an NPC or sign says the first thing its script says,
anything else does nothing. Translator.report lists the stand-ins.

The names a script uses are translated by a Names object (see
import_kanto_scripts.py): flags, vars, items, sounds and the like.
"""
import re
from dataclasses import dataclass, field


class Unsupported(Exception):
    pass


CONDITIONS = {"lt": "0", "eq": "1", "gt": "2", "le": "3", "ge": "4", "ne": "5", "TRUE": "1", "FALSE": "0"}
COND_SUFFIX = {"Lt": "0", "Eq": "1", "Gt": "2", "Le": "3", "Ge": "4", "Ne": "5"}

# Commands Platinum has no use for: HGSS's following Pokémon, touch screen
# menus, Pokégear, game stats and the like.
DROPPED = {
    "ToggleFollowingPokemonMovement", "WaitFollowingPokemonMovement", "FollowingPokemonMovement",
    "ScrCmd_609", "TouchscreenMenuHide", "TouchscreenMenuShow", "SetFollowMonInhibitState",
    "AddSpecialGameStat", "NopVar490", "Dummy486", "Noop", "HoldMsg", "StopBGM", "PlayBGM",
    "FadeOutBGM", "RestoreOverworld", "ScrCmd_602", "ScrCmd_603", "ScrCmd_604",
}

# HGSS std scripts (CallStd) -> Platinum lines.
STD_SCRIPTS = {
    "std_give_item_verbose": ["Common_GiveItemQuantity"],
    "std_obtain_item_verbose": ["Common_GiveItemQuantity"],
    "std_bag_is_full": ["Common_MessageBagIsFull"],
    "std_mart_intro": ["Common_VendorGreeting", "CloseMessageWithoutErasing"],
    "std_pokemart": ["PokeMartCommon"],
    # HGSS passes the nurse's object in VAR_SPECIAL_x8007, as Platinum does.
    "std_nurse_joy": ["CallCommonScript 0x7D2"],
    "std_prompt_save": ["Common_SaveGame"],
}
# Music played around scenes; Platinum keeps the map's music.
STD_DROPPED = re.compile(r"std_(play|fade_end)_\w+_music$")

# Movement actions HGSS has and Platinum doesn't.
MOVEMENT_RENAMES = {"EmoteQuestionMark": "Delay8", "EmoteExclamation2": "EmoteExclamationMark", "NurseJoyBow": "Delay8"}


@dataclass
class Block:
    label: str
    lines: list = field(default_factory=list)  # (command, args)
    movement: bool = False


def split_args(text):
    return [a.strip() for a in text.split(",")] if text.strip() else []


def parse(text):
    """HGSS scr_seq file -> (entry labels, blocks in file order)."""
    entries, blocks = [], []
    current = None
    balign = False
    for raw in text.splitlines():
        line = raw.split("//")[0].strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith(".balign"):
            balign = True
            continue
        if line.startswith("."):
            continue
        if line.endswith(":"):
            current = Block(line[:-1], movement=balign)
            balign = False
            blocks.append(current)
            continue
        cmd, _, rest = line.partition(" ")
        if cmd == "ScrDef":
            entries.append(rest.strip())
        elif cmd in ("ScrDefEnd", ";"):
            continue
        elif current is not None:
            current.lines.append((cmd, split_args(rest)))
    return entries, blocks


TERMINATORS = {"End", "GoTo", "Return", "EndMovement"}
BRANCHES = re.compile(r"^(GoTo|Call)(If\w*)?$|^Case$|^GoToIfNoItemSpace$|^GoToIf(Set|Unset|Defeated|NotDefeated)$|^CallIf(Set|Unset|Defeated|NotDefeated)$")


class Translator:
    def __init__(self, names):
        self.names = names
        self.report = []

    # ------------------------------------------------------------ reachability
    def reachable(self, start, blocks, index):
        """Labels reachable from start, following branches and fall through."""
        seen, todo = set(), [start]
        while todo:
            label = todo.pop()
            if label in seen or label not in index:
                continue
            seen.add(label)
            i = index[label]
            block = blocks[i]
            for cmd, args in block.lines:
                if cmd == "ApplyMovement" and len(args) == 2:
                    todo.append(args[1])
                elif BRANCHES.match(cmd) and args:
                    todo.append(args[-1])
            last = block.lines[-1][0] if block.lines else None
            if last not in TERMINATORS and i + 1 < len(blocks):
                todo.append(blocks[i + 1].label)
        return seen

    # --------------------------------------------------------------- commands
    def arg(self, a):
        return self.names.value(a)

    def cond(self, c):
        return CONDITIONS.get(c, c)

    def command(self, cmd, args, ctx):
        """One HGSS command -> list of Platinum lines."""
        a = args
        v = self.arg
        if cmd in DROPPED or "obj_partner_poke" in args:
            # Platinum has no Pokémon following the player.
            return []
        if cmd == "End":
            return ["End"]
        if cmd == "Return":
            return ["Return"]
        if cmd == "GoTo":
            return [f"GoTo {a[0]}"]
        if cmd == "Call":
            return [f"Call {a[0]}"]
        if cmd == "Compare":
            return [f"CompareVar {v(a[0])}, {v(a[1])}"]
        if cmd in ("CompareVarToValue", "CompareVarToVar"):
            return [f"{cmd} {v(a[0])}, {v(a[1])}"]
        if cmd in ("GoToIf", "CallIf"):
            return [f"{cmd} {self.cond(a[0])}, {a[1]}"]
        m = re.match(r"^(GoTo|Call)If(Lt|Eq|Gt|Le|Ge|Ne)$", cmd)
        if m:
            return [f"{m.group(1)}If {COND_SUFFIX[m.group(2)]}, {a[0]}"]
        m = re.match(r"^(GoTo|Call)If(Set|Unset)$", cmd)
        if m:
            return [f"CheckFlag {v(a[0])}", f"{m.group(1)}If {'1' if m.group(2) == 'Set' else '0'}, {a[1]}"]
        if cmd == "CheckFlag":
            return [f"CheckFlag {v(a[0])}"]
        if cmd in ("SetFlag", "ClearFlag"):
            return [f"{cmd} {v(a[0])}"]
        if cmd in ("SetVar", "CopyVar", "SetOrCopyVar"):
            return [f"SetVar {v(a[0])}, {v(a[1])}"]
        if cmd == "AddVar":
            return [f"AddVar {v(a[0])}, {v(a[1])}"]
        if cmd == "SubVar":
            return [f"SubVar {v(a[0])}, {v(a[1])}"]
        if cmd == "Switch":
            return [f"SetVar VAR_0x8008, {v(a[0])}"]
        if cmd == "Case":
            return [f"CompareVar VAR_0x8008, {v(a[0])}", f"GoToIf 1, {a[1]}"]
        if cmd in ("NPCMsg", "NonNPCMsg"):
            return [f"Message {self.names.message(a[0])}"]
        if cmd == "SimpleNPCMsg":
            return [f"NPCMessage {self.names.message(a[0])}"]
        if cmd == "GenderMsgBox":
            male, female = self.names.message(a[0]), self.names.message(a[1])
            n = ctx.unique()
            return ["GetPlayerGender VAR_RESULT", f"GoToIfEq VAR_RESULT, GENDER_FEMALE, {n}_Female",
                    f"Message {male}", f"GoTo {n}_Done", f"{n}_Female:", f"Message {female}", f"{n}_Done:"]
        if cmd in ("WaitButton", "WaitABPress", "LockAll", "ReleaseAll", "FacePlayer", "WaitMovement", "HealParty", "WaitCry", "WaitFanfare"):
            return [cmd]
        if cmd == "CloseMsg":
            return ["CloseMessage"]
        if cmd == "Lock":
            return [f"LockObject {v(a[0])}"]
        if cmd == "Release":
            return [f"ReleaseObject {v(a[0])}"]
        if cmd == "ApplyMovement":
            return [f"ApplyMovement {v(a[0])}, {a[1]}"]
        if cmd == "HidePerson":
            return [f"RemoveObject {v(a[0])}"]
        if cmd == "ShowPerson":
            return [f"AddObject {v(a[0])}"]
        if cmd == "MakeObjectVisible":
            return [f"ShowObject {v(a[0])}"]
        if cmd == "FadeScreen":
            return [f"FadeScreen {a[0]}, {a[1]}, {a[2]}, {v(a[3])}"]
        if cmd == "WaitFade":
            return ["WaitFadeScreen"]
        if cmd == "Wait":
            return [f"WaitTime {a[0]}, {v(a[1])}"]
        if cmd == "PlaySE":
            se = self.names.sound(a[0])
            return [f"PlaySE {se}"] if se else []
        if cmd in ("WaitSE", "StopSE"):
            se = self.names.sound(a[0])
            return [f"{cmd} {se}"] if se else []
        if cmd == "PlayFanfare":
            fanfare = self.names.fanfare(a[0])
            return [f"PlayFanfare {fanfare}"] if fanfare else []
        if cmd == "PlayCry":
            return [f"PlayCry {v(a[0])}"]
        if cmd == "CallStd":
            return self.std(a[0], ctx)
        if cmd == "GetPlayerFacing":
            return [f"GetPlayerDir {v(a[0])}"]
        if cmd == "GetWeekday":
            return [f"GetDayOfWeek {v(a[0])}"]
        if cmd == "ScrCmd_522":
            return [f"GetHour {v(a[0])}"]
        if cmd == "ScrCmd_379":
            return [f"GetTimeOfDay {v(a[0])}"]
        if cmd == "ScrCmd_729":
            # Whether a Pokémon follows the player: never in Platinum.
            return [f"SetVar {v(a[0])}, 0"]
        if cmd == "GetGameVersion":
            return [f"SetVar {v(a[0])}, 7"]  # HeartGold's version ID
        if cmd == "GetPlayerGender":
            return [f"GetPlayerGender {v(a[0])}"]
        if cmd == "Random":
            return [f"GetRandom {v(a[0])}, {v(a[1])}"]
        if cmd == "GetPartyCount":
            return [f"GetPartyCount {v(a[0])}"]
        if cmd == "GetPartyMonSpecies":
            return [f"GetPartyMonSpecies {v(a[0])}, {v(a[1])}"]
        if cmd == "GetPlayerCoords":
            # Scripts compare these with HGSS's coordinates.
            dx, dz = ctx.world_offset
            out = [f"GetPlayerMapPos {v(a[0])}, {v(a[1])}"]
            if dx or dz:
                out += [f"AddVar {v(a[0])}, {dx}", f"AddVar {v(a[1])}, {dz}"]
            return out
        if cmd == "BufferPlayersName":
            return [f"BufferPlayerName {a[0]}"]
        if cmd == "BufferRivalsName":
            return [f"BufferRivalName {a[0]}"]
        if cmd == "BufferItemName":
            return [f"BufferItemName {a[0]}, {v(a[1])}"]
        if cmd == "BufferPocketName":
            return [f"BufferPocketName {a[0]}, {v(a[1])}"]
        if cmd == "BufferPartyMonNick":
            return [f"BufferPartyMonNickname {a[0]}, {v(a[1])}"]
        if cmd == "BufferInt":
            return [f"BufferNumber {a[0]}, {v(a[1])}"]
        if cmd == "BufferSpeciesName":
            return [f"BufferSpeciesNameFromVar {a[0]}, {v(a[1])}, 0, 0"]
        if cmd == "BufferMoveName":
            return [f"BufferMoveName {a[0]}, {v(a[1])}"]
        if cmd == "GetItemPocket":
            return [f"GetItemPocket {v(a[0])}, {v(a[1])}"]
        if cmd == "HasItem":
            return [f"CheckItem {v(a[0])}, {v(a[1])}, {v(a[2])}"]
        if cmd == "HasSpaceForItem":
            return [f"CanFitItem {v(a[0])}, {v(a[1])}, {v(a[2])}"]
        if cmd == "GiveItem":
            return [f"AddItem {v(a[0])}, {v(a[1])}, {v(a[2])}"]
        if cmd == "TakeItem":
            return [f"RemoveItem {v(a[0])}, {v(a[1])}, {v(a[2])}"]
        if cmd == "ItemVars":
            return self.item_vars(a)
        if cmd == "GiveItemNoCheck":
            return self.item_vars(a) + ["Common_GiveItemQuantity"]
        if cmd == "GoToIfNoItemSpace":
            return self.item_vars(a[:2]) + ["CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT", f"GoToIfEq VAR_RESULT, FALSE, {a[2]}"]
        if cmd == "CheckBadge":
            return self.names.badge_check(a[0], v(a[1]))
        if cmd == "GiveBadge":
            return [f"GiveBadge {self.names.badge(a[0])}"]
        if cmd == "SetTrainerFlag":
            return [f"SetTrainerFlag {self.names.trainer(a[0])}"]
        if cmd == "CheckBattleWon":
            return [f"CheckWonBattle {v(a[0])}"]
        if cmd == "WhiteOut":
            return ["BlackOutFromBattle"]
        if cmd == "WildBattle":
            return [f"StartWildBattle {v(a[0])}, {v(a[1])}"]
        if cmd == "GiveMon":
            return [f"GivePokemon {v(a[0])}, {v(a[1])}, {v(a[2])}, {v(a[5])}"]
        if cmd == "Warp":
            return self.names.warp(a)
        if cmd == "MenuInit":
            # x, y, cursor, can exit with B, selection var
            return [f"InitLocalTextMenu {a[0]}, {a[1]}, {a[2]}, {v(a[4])}, {a[3]}"]
        if cmd == "MenuItemAdd":
            return [f"AddMenuEntryImm {self.names.message(a[0])}, {a[2]}"]
        if cmd == "MenuExec":
            return ["ShowMenu"]
        if cmd == "GetMenuChoice":
            return [f"ShowYesNoMenu {v(a[0])}"]
        if cmd == "ShowMoneyBox":
            return [f"ShowMoney {a[0]}, {a[1]}"]
        if cmd == "HideMoneyBox":
            return ["HideMoney"]
        if cmd == "UpdateMoneyBox":
            return ["UpdateMoneyDisplay"]
        if cmd == "HasEnoughMoneyImmediate":
            return [f"CheckMoney {v(a[0])}, {a[1]}"]
        if cmd == "SubMoneyImmediate":
            return [f"RemoveMoney {a[0]}"]
        if cmd == "GetPartyLeadAlive":
            return [f"GetFirstNonEggInParty {v(a[0])}"]
        if cmd == "MonHasMove":
            return [f"CheckPartyMonHasMove {v(a[0])}, {v(a[1])}, {v(a[2])}"]
        if cmd == "GetItemQuantity":
            return [f"GetItemQuantity {v(a[0])}, {v(a[1])}"]
        if cmd == "GetPartySlotWithSpecies":
            return [f"FindPartySlotWithSpecies {v(a[0])}, {v(a[1])}"]
        if cmd == "MovePersonFacing":
            # person, x, y, z, direction, in HGSS's coordinates
            x, z = self.coord(a[1], ctx.world_offset[0]), self.coord(a[3], ctx.world_offset[1])
            return [f"SetPosition {v(a[0])}, {x}, {a[2]}, {z}, {v(a[4])}"]
        if cmd == "SetObjectFacing":
            return [f"SetObjectEventDir {v(a[0])}, {a[1]}"]
        if cmd == "TrainerTipsEx":
            return [f"{'ShowLandmarkSign' if a[0] == '2' else 'ShowScrollingSign'} {self.names.message(a[1])}"]
        if cmd == "DirectionSignpostEx":
            # type, picture, message; the pictures are HGSS's (kanto_signs.py).
            msg = self.names.message(a[2])
            sign_type = {"0": "SIGNPOST_TYPE_MAP", "1": "SIGNPOST_TYPE_ARROW"}.get(a[0])
            if sign_type is None or a[1] == "0":
                return [f"ShowLandmarkSign {msg}"]
            return [f"DrawSignpostInstantMessage {msg}, {sign_type}, {a[1]}", "SetSignpostCommand SIGNPOST_CMD_SCROLL_IN",
                    "WaitForSignpostDone", "GetSignpostInput VAR_RESULT", "Common_HandleSignpostInput"]
        raise Unsupported(cmd)

    def coord(self, value, offset):
        if re.fullmatch(r"\d+", value):
            return str(int(value) - offset)
        if offset:
            raise Unsupported("coordinates in a var")
        return self.arg(value)

    def item_vars(self, a):
        item, qty = a[0], a[1] if len(a) > 1 else "1"
        return [f"SetVar VAR_0x8004, {self.arg(item)}", f"SetVar VAR_0x8005, {self.arg(qty)}"]

    def std(self, name, ctx):
        if STD_DROPPED.match(name):
            return []
        if name == "std_special_mart":
            if ctx.mart_id is None:
                raise Unsupported("std_special_mart without a mart")
            return [f"PokeMartSpecialties {self.names.mart(ctx.mart_id)}"]
        if name in STD_SCRIPTS:
            return STD_SCRIPTS[name]
        raise Unsupported(name)

    # ------------------------------------------------------------------ files
    def translate_block(self, block, ctx):
        out = []
        ctx.mart_id = None
        for cmd, args in block.lines:
            if block.movement:
                name = MOVEMENT_RENAMES.get(cmd, cmd)
                out.append(" ".join([name] + [", ".join(args)]).strip())
                continue
            if cmd == "SetVar" and args and args[0] == "VAR_SPECIAL_x8004" and args[1].isdigit():
                ctx.mart_id = int(args[1])
            out += self.command(cmd, args, ctx)
        return out

    def first_message(self, label, blocks, index, reach):
        for b in blocks:
            if b.label not in reach or b.movement:
                continue
            for cmd, args in b.lines:
                if cmd in ("NPCMsg", "NonNPCMsg", "SimpleNPCMsg") and args and args[0].startswith("msg_"):
                    return args[0]
                if cmd in ("TrainerTipsEx",):
                    return args[1]
                if cmd in ("DirectionSignpostEx",):
                    return args[2]
        return None

    def translate_file(self, text, ctx):
        """-> list of Platinum lines (after the #includes)."""
        entries, blocks = parse(text)
        index = {b.label: i for i, b in enumerate(blocks)}
        translated = {}
        failed = {}
        for b in blocks:
            try:
                translated[b.label] = self.translate_block(b, ctx)
            except Unsupported as e:
                failed[b.label] = str(e)
            except (IndexError, KeyError) as e:
                failed[b.label] = f"bad arguments ({e})"
        good_entries, stand_ins = [], {}
        keep = set()
        for n, entry in enumerate(entries):
            reach = self.reachable(entry, blocks, index)
            bad = sorted({failed[l] for l in reach if l in failed})
            if bad:
                msg = self.first_message(entry, blocks, index, reach)
                stand_ins[entry] = self.stand_in(entry, msg, ctx.entry_kinds.get(n + 1, "other"))
                self.report.append((ctx.name, entry, bad))
            else:
                good_entries.append(entry)
                keep |= reach
        out = [f"    ScriptEntry {e if e not in stand_ins else e + '_StandIn'}" for e in entries]
        out += ["    ScriptEntryEnd", ""]
        for b in blocks:
            if b.label not in keep:
                continue
            if b.movement:
                out.append("    .balign 4, 0")
            out.append(f"{b.label}:")
            for line in translated[b.label]:
                out.append(line if line.endswith(":") else "    " + line)
            out.append("")
        for entry, lines in stand_ins.items():
            out.append(f"{entry}_StandIn:")
            out += ["    " + l for l in lines]
            out.append("")
        out.append("    .balign 4, 0")
        return out, len(entries) - len(stand_ins), len(stand_ins)

    def stand_in(self, entry, msg, kind):
        if msg and kind in ("object", "bg"):
            msg = self.names.message(msg)
            face = ["FacePlayer"] if kind == "object" else []
            return ["PlaySE SE_CONFIRM_sseq_3", "LockAll"] + face + [
                "BufferPlayerName 0", f"Message {msg}", "WaitButton", "CloseMessage", "ReleaseAll", "End"]
        return ["End"]


@dataclass
class FileContext:
    name: str
    world_offset: tuple
    entry_kinds: dict  # 1-based script number -> "object", "bg", "coord" or "init"
    mart_id: int = None
    counter: int = 0

    def unique(self):
        self.counter += 1
        return f"_Gen{self.counter:03d}"
