#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0327_r03pc0101.h"
#include "res/field/events/kanto_events_463_r03pc0101.h"


    ScriptEntry scr_seq_R03PC0101_000
    ScriptEntry scr_seq_R03PC0101_001
    ScriptEntry scr_seq_R03PC0101_002
    ScriptEntryEnd

scr_seq_R03PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_R03PC0101_001:
    NPCMessage msg_0327_R03PC0101_00000
    End

scr_seq_R03PC0101_002:
    NPCMessage msg_0327_R03PC0101_00001
    End

    .balign 4, 0
