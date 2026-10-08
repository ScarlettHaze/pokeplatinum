#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0467_t04.h"
#include "res/field/events/kanto_events_049_t04.h"


    ScriptEntry scr_seq_T04_000
    ScriptEntry scr_seq_T04_001
    ScriptEntry scr_seq_T04_002
    ScriptEntry scr_seq_T04_003
    ScriptEntry scr_seq_T04_004
    ScriptEntry scr_seq_T04_005
    ScriptEntry scr_seq_T04_006
    ScriptEntry scr_seq_T04_007
    ScriptEntry scr_seq_T04_008
    ScriptEntry scr_seq_T04_009
    ScriptEntry scr_seq_T04_010
    ScriptEntry scr_seq_T04_011_StandIn
    ScriptEntry scr_seq_T04_012
    ScriptEntry scr_seq_T04_013
    ScriptEntryEnd

scr_seq_T04_012:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _004B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_004B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _006F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _006F
    SetFlag FLAG_UNK_0x0041
    End

_006F:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_T04_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _0093
    Message msg_0467_T04_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0093:
    Message msg_0467_T04_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04_001:
    NPCMessage msg_0467_T04_00002
    End

scr_seq_T04_002:
    NPCMessage msg_0467_T04_00005
    End

scr_seq_T04_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0467_T04_00003
    PlayCry SPECIES_SLOWBRO
    WaitCry
    Message msg_0467_T04_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_ICEBERG_RUINS_STATE, 3
    GoToIf 4, _012C
    CompareVar VAR_ROUTE_227_WAKE_RIVAL_STATE, 2
    GoToIf 1, _0123
    CompareVar VAR_ROUTE_227_WAKE_RIVAL_STATE, 1
    GoToIf 1, _011A
    Message msg_0467_T04_00006
    GoTo _012F

_011A:
    Message msg_0467_T04_00007
    GoTo _012F

_0123:
    Message msg_0467_T04_00008
    GoTo _012F

_012C:
    Message msg_0467_T04_00009

_012F:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0467_T04_00010
    Message msg_0467_T04_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04_013:
    NPCMessage msg_0467_T04_00012
    End

scr_seq_T04_006:
    DrawSignpostInstantMessage msg_0467_T04_00013, SIGNPOST_TYPE_MAP, 4
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T04_007:
    ShowLandmarkSign msg_0467_T04_00014
    End

scr_seq_T04_008:
    ShowLandmarkSign msg_0467_T04_00015
    End

scr_seq_T04_009:
    ShowScrollingSign msg_0467_T04_00016
    End

scr_seq_T04_010:
    DrawSignpostInstantMessage msg_0467_T04_00017, SIGNPOST_TYPE_ARROW, 14
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T04_011_StandIn:
    End

    .balign 4, 0
