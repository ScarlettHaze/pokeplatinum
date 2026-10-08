#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0493_t07pc0101.h"
#include "res/field/events/kanto_events_350_t07pc0101.h"


    ScriptEntry scr_seq_T07PC0101_000
    ScriptEntry scr_seq_T07PC0101_001
    ScriptEntry scr_seq_T07PC0101_002
    ScriptEntry scr_seq_T07PC0101_003
    ScriptEntryEnd

scr_seq_T07PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T07PC0101_001:
    NPCMessage msg_0493_T07PC0101_00000
    End

scr_seq_T07PC0101_002:
    NPCMessage msg_0493_T07PC0101_00001
    End

scr_seq_T07PC0101_003:
    NPCMessage msg_0493_T07PC0101_00002
    End

    .balign 4, 0
