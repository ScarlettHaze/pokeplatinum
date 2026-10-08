#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0342_r10pc0101.h"
#include "res/field/events/kanto_events_420_r10pc0101.h"


    ScriptEntry scr_seq_R10PC0101_000
    ScriptEntry scr_seq_R10PC0101_001
    ScriptEntry scr_seq_R10PC0101_002
    ScriptEntry scr_seq_R10PC0101_003
    ScriptEntryEnd

scr_seq_R10PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_R10PC0101_001:
    NPCMessage msg_0342_R10PC0101_00000
    End

scr_seq_R10PC0101_002:
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _004F
    NPCMessage msg_0342_R10PC0101_00001
    End

_004F:
    NPCMessage msg_0342_R10PC0101_00002
    End

scr_seq_R10PC0101_003:
    NPCMessage msg_0342_R10PC0101_00003
    End

    .balign 4, 0
