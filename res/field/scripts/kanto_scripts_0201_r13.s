#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0350_r13.h"
#include "res/field/events/kanto_events_018_r13.h"


    ScriptEntry scr_seq_R13_000
    ScriptEntry scr_seq_R13_001
    ScriptEntry scr_seq_R13_002
    ScriptEntryEnd

scr_seq_R13_000:
    ShowScrollingSign msg_0350_R13_00000
    End

scr_seq_R13_001:
    DrawSignpostInstantMessage msg_0350_R13_00001, SIGNPOST_TYPE_ARROW, 10
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R13_002:
    DrawSignpostInstantMessage msg_0350_R13_00002, SIGNPOST_TYPE_ARROW, 14
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

    .balign 4, 0
