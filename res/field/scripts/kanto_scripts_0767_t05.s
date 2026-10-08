#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0475_t05.h"
#include "res/field/events/kanto_events_050_t05.h"


    ScriptEntry scr_seq_T05_000
    ScriptEntry scr_seq_T05_001
    ScriptEntry scr_seq_T05_002
    ScriptEntry scr_seq_T05_003
    ScriptEntry scr_seq_T05_004
    ScriptEntry scr_seq_T05_005
    ScriptEntry scr_seq_T05_006
    ScriptEntry scr_seq_T05_007
    ScriptEntryEnd

scr_seq_T05_000:
    NPCMessage msg_0475_T05_00000
    End

scr_seq_T05_001:
    NPCMessage msg_0475_T05_00001
    End

scr_seq_T05_002:
    NPCMessage msg_0475_T05_00002
    End

scr_seq_T05_003:
    NPCMessage msg_0475_T05_00003
    End

scr_seq_T05_004:
    DrawSignpostInstantMessage msg_0475_T05_00004, SIGNPOST_TYPE_MAP, 5
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T05_005:
    ShowLandmarkSign msg_0475_T05_00005
    End

scr_seq_T05_006:
    ShowLandmarkSign msg_0475_T05_00006
    End

scr_seq_T05_007:
    ShowLandmarkSign msg_0475_T05_00007
    End

    .balign 4, 0
