#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0358_r18.h"
#include "res/field/events/kanto_events_023_r18.h"


    ScriptEntry scr_seq_R18_000_StandIn
    ScriptEntry scr_seq_R18_001
    ScriptEntryEnd

scr_seq_R18_001:
    DrawSignpostInstantMessage msg_0358_R18_00000, SIGNPOST_TYPE_ARROW, 1
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R18_000_StandIn:
    End

    .balign 4, 0
