#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0348_r12.h"
#include "res/field/events/kanto_events_017_r12.h"


    ScriptEntry scr_seq_R12_000_StandIn
    ScriptEntry scr_seq_R12_001
    ScriptEntry scr_seq_R12_002
    ScriptEntry scr_seq_R12_003
    ScriptEntry scr_seq_R12_004
    ScriptEntry scr_seq_R12_005_StandIn
    ScriptEntryEnd

scr_seq_R12_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _002B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_002B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _004F
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _004F
    SetFlag FLAG_UNK_0x0041
    End

_004F:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_R12_004:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _006D
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_NORTHEAST_HOUSE_PINK_SCARF
    GoToIf 1, _0087
    End

_006D:
    SetFlag FLAG_UNK_0x0053
    RemoveObject obj_R12_kabigon
    RemoveObject obj_R12_gsbabyboy1
    RemoveObject obj_R12_gsbabyboy1_2
    RemoveObject obj_R12_gsbabyboy1_3
    ClearFlag FLAG_UNUSED_0x0122
    End

_0087:
    End

scr_seq_R12_002:
    DrawSignpostInstantMessage msg_0348_R12_00000, SIGNPOST_TYPE_ARROW, 3
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R12_003:
    ShowLandmarkSign msg_0348_R12_00001
    End

scr_seq_R12_000_StandIn:
    End

scr_seq_R12_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0348_R12_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
