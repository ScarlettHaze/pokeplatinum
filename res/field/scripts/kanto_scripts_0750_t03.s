#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0460_t03.h"
#include "res/field/events/kanto_events_048_t03.h"


    ScriptEntry scr_seq_T03_000_StandIn
    ScriptEntry scr_seq_T03_001
    ScriptEntry scr_seq_T03_002
    ScriptEntry scr_seq_T03_003
    ScriptEntry scr_seq_T03_004
    ScriptEntry scr_seq_T03_005
    ScriptEntry scr_seq_T03_006
    ScriptEntry scr_seq_T03_007_StandIn
    ScriptEntry scr_seq_T03_008
    ScriptEntry scr_seq_T03_009
    ScriptEntry scr_seq_T03_010_StandIn
    ScriptEntry scr_seq_T03_011
    ScriptEntry scr_seq_T03_012
    ScriptEntry scr_seq_T03_013
    ScriptEntryEnd

scr_seq_T03_008:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _004B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_004B:
    GoTo _030E

_0051:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0075
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0075
    SetFlag FLAG_UNK_0x0041
    End

_0075:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_T03_001:
    NPCMessage msg_0460_T03_00000
    End

scr_seq_T03_002:
    NPCMessage msg_0460_T03_00001
    End

scr_seq_T03_003:
    DrawSignpostInstantMessage msg_0460_T03_00020, SIGNPOST_TYPE_MAP, 3
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T03_004:
    ShowLandmarkSign msg_0460_T03_00021
    End

scr_seq_T03_005:
    ShowLandmarkSign msg_0460_T03_00022
    End

scr_seq_T03_006:
    ShowLandmarkSign msg_0460_T03_00023
    End

_030E:
    CompareVar VAR_PASTORIA_CITY_STATE, 4
    GoToIf 1, _0341
    CompareVar VAR_PASTORIA_CITY_STATE, 2
    GoToIf 1, _033D
    CompareVar VAR_PASTORIA_CITY_STATE, 3
    GoToIf 1, _033D
    GoTo _0051
    End

_033D:
    ClearFlag FLAG_UNUSED_0x006D

_0341:
    SetVar VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _035C
    ClearFlag FLAG_TALKED_TO_RIVAL_HOUSE_RIVAL_MOM_RIVAL_LEFT
    GoTo _0360

_035C:
    ClearFlag FLAG_UNUSED_0x006F

_0360:
    End

scr_seq_T03_011:
    CompareVar VAR_PASTORIA_CITY_STATE, 2
    GoToIf 1, _0371
    End

_0371:
    SetPosition obj_T03_daigo, 375, 6, 81, DIR_WEST
    End

scr_seq_T03_013:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _038C
    End

_038C:
    SetVar VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _03AB
    SetFlag FLAG_TALKED_TO_RIVAL_HOUSE_RIVAL_MOM_RIVAL_LEFT
    RemoveObject obj_T03_tsure_poke_static_latios
    GoTo _03B3

_03AB:
    SetFlag FLAG_UNUSED_0x006F
    RemoveObject obj_T03_tsure_poke_static_latias

_03B3:
    End

scr_seq_T03_012:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0440
    WaitMovement
    ApplyMovement obj_T03_daigo, _045C
    WaitMovement
    SetVar VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _03F1
    Message msg_0460_T03_00006
    GoTo _03F4

_03F1:
    Message msg_0460_T03_00007

_03F4:
    CloseMessage
    ApplyMovement obj_T03_daigo, _0464
    ApplyMovement LOCALID_PLAYER, _0464
    WaitMovement
    SetVar VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _042C
    Message msg_0460_T03_00008
    GoTo _042F

_042C:
    Message msg_0460_T03_00009

_042F:
    WaitButton
    CloseMessage
    SetVar VAR_PASTORIA_CITY_STATE, 3
    ReleaseAll
    End

    .balign 4, 0
_0440:
    WalkNormalSouth 4
    FaceWest
    EndMovement

    .balign 4, 0
_045C:
    WalkOnSpotNormalSouth
    EndMovement

    .balign 4, 0
_0464:
    WalkNormalWest 3
    EndMovement

scr_seq_T03_009:
    NPCMessage msg_0460_T03_00019
    End

scr_seq_T03_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0460_T03_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03_007_StandIn:
    End

scr_seq_T03_010_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0460_T03_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
