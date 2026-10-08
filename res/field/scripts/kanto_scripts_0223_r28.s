#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0371_r28.h"
#include "res/field/events/kanto_events_029_r28.h"


    ScriptEntry scr_seq_R28_000
    ScriptEntry scr_seq_R28_001
    ScriptEntryEnd

scr_seq_R28_000:
    SetVar VAR_UNUSED_0x408F, 0
    End

scr_seq_R28_001:
    DrawSignpostInstantMessage msg_0371_R28_00000, SIGNPOST_TYPE_ARROW, 2
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

    .balign 4, 0
