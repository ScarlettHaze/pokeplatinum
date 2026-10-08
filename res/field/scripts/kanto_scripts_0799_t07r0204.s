#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0504_t07r0204.h"
#include "res/field/events/kanto_events_336_t07r0204.h"


    ScriptEntry scr_seq_T07R0204_000
    ScriptEntry scr_seq_T07R0204_001
    ScriptEntryEnd

scr_seq_T07R0204_001:
    SetVar VAR_ROUTE_217_STATE, 0
    End

scr_seq_T07R0204_000:
    NPCMessage msg_0504_T07R0204_00000
    End

    .balign 4, 0
