#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0346_r11.h"
#include "res/field/events/kanto_events_016_r11.h"


    ScriptEntry scr_seq_R11_000_StandIn
    ScriptEntry scr_seq_R11_001
    ScriptEntry scr_seq_R11_002
    ScriptEntry scr_seq_R11_003
    ScriptEntryEnd

scr_seq_R11_001:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _002A
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_NORTHEAST_HOUSE_PINK_SCARF
    GoToIf 1, _0044
    End

_002A:
    SetFlag FLAG_UNK_0x004F
    RemoveObject obj_R11_kabigon
    RemoveObject obj_R11_gsbabyboy1_2
    RemoveObject obj_R11_gsbabyboy1
    RemoveObject obj_R11_gsbabyboy1_3
    ClearFlag FLAG_UNUSED_0x0122
    End

_0044:
    End

scr_seq_R11_002:
    DrawSignpostInstantMessage msg_0346_R11_00000, SIGNPOST_TYPE_ARROW, 2
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R11_003:
    ShowLandmarkSign msg_0346_R11_00001
    End

scr_seq_R11_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0346_R11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
