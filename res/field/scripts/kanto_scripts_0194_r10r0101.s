#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0343_r10r0101.h"
#include "res/field/events/kanto_events_345_r10r0101.h"


    ScriptEntry scr_seq_R10R0101_000
    ScriptEntryEnd

scr_seq_R10R0101_000:
    DrawSignpostInstantMessage msg_0343_R10R0101_00000, SIGNPOST_TYPE_ARROW, 3
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

    .balign 4, 0
