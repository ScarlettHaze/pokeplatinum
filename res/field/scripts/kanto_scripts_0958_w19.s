#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0740_w19.h"
#include "res/field/events/kanto_events_088_w19.h"


    ScriptEntry scr_seq_W19_000
    ScriptEntry scr_seq_W19_001
    ScriptEntry scr_seq_W19_002
    ScriptEntry scr_seq_W19_003
    ScriptEntry scr_seq_W19_004
    ScriptEntry scr_seq_W19_005
    ScriptEntryEnd

scr_seq_W19_000:
    NPCMessage msg_0740_W19_00000
    End

scr_seq_W19_001:
    NPCMessage msg_0740_W19_00002
    End

scr_seq_W19_002:
    NPCMessage msg_0740_W19_00001
    End

scr_seq_W19_003:
    NPCMessage msg_0740_W19_00003
    End

scr_seq_W19_004:
    DrawSignpostInstantMessage msg_0740_W19_00004, SIGNPOST_TYPE_ARROW, 4
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_W19_005:
    ShowScrollingSign msg_0740_W19_00005
    End

    .balign 4, 0
