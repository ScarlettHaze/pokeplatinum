#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0519_t09.h"
#include "res/field/events/kanto_events_054_t09.h"


    ScriptEntry scr_seq_T09_000_StandIn
    ScriptEntry scr_seq_T09_001
    ScriptEntry scr_seq_T09_002
    ScriptEntry scr_seq_T09_003_StandIn
    ScriptEntry scr_seq_T09_004_StandIn
    ScriptEntryEnd

scr_seq_T09_001:
    ShowLandmarkSign msg_0519_T09_00020
    End

scr_seq_T09_002:
    DrawSignpostInstantMessage msg_0519_T09_00021, SIGNPOST_TYPE_MAP, 9
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T09_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0519_T09_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T09_003_StandIn:
    End

scr_seq_T09_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0519_T09_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
