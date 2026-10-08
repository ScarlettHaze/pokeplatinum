#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0477_t05pc0101.h"
#include "res/field/events/kanto_events_389_t05pc0101.h"


    ScriptEntry scr_seq_T05PC0101_000
    ScriptEntry scr_seq_T05PC0101_001
    ScriptEntry scr_seq_T05PC0101_002
    ScriptEntry scr_seq_T05PC0101_003
    ScriptEntryEnd

scr_seq_T05PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T05PC0101_001:
    NPCMessage msg_0477_T05PC0101_00000
    End

scr_seq_T05PC0101_002:
    NPCMessage msg_0477_T05PC0101_00001
    End

scr_seq_T05PC0101_003:
    NPCMessage msg_0477_T05PC0101_00002
    End

    .balign 4, 0
