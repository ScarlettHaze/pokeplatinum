#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0320_r02.h"
#include "res/field/events/kanto_events_007_r02.h"


    ScriptEntry scr_seq_R02_000
    ScriptEntryEnd

scr_seq_R02_000:
    DrawSignpostInstantMessage msg_0320_R02_00000, SIGNPOST_TYPE_ARROW, 3
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

    .balign 4, 0
