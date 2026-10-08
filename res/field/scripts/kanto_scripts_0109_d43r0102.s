#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0003_everywhere.h"
#include "res/field/events/kanto_events_171_d43r0102.h"


    ScriptEntry scr_seq_D43R0102_000_StandIn
    ScriptEntry scr_seq_D43R0102_001
    ScriptEntryEnd

scr_seq_D43R0102_001:
    CompareVar VAR_ROUTE_224_STATE, 1
    GoToIf 5, _0043
    ShowObject LOCALID_PLAYER

_0043:
    End

scr_seq_D43R0102_000_StandIn:
    End

    .balign 4, 0
