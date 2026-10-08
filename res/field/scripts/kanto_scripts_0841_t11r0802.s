#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0541_t11r0802.h"
#include "res/field/events/kanto_events_362_t11r0802.h"


    ScriptEntry scr_seq_T11R0802_000_StandIn
    ScriptEntry scr_seq_T11R0802_001
    ScriptEntry scr_seq_T11R0802_002
    ScriptEntry scr_seq_T11R0802_003
    ScriptEntry scr_seq_T11R0802_004
    ScriptEntry scr_seq_T11R0802_005
    ScriptEntry scr_seq_T11R0802_006
    ScriptEntryEnd

scr_seq_T11R0802_004:
    GetPlayerGender VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _003B
    SetVar VAR_OBJ_GFX_ID_0, 0
    GoTo _0041

_003B:
    SetVar VAR_OBJ_GFX_ID_0, 97

_0041:
    End

scr_seq_T11R0802_005:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _005A
    RemoveObject obj_T11R0802_var_1
    SetVar VAR_MAP_LOCAL_0x0B, 1

_005A:
    End

scr_seq_T11R0802_003:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _03A3
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0541_T11R0802_00012
    WaitButton
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0359
    ApplyMovement obj_T11R0802_jupetta, _03C8
    GoTo _0397

_0359:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0374
    ApplyMovement obj_T11R0802_jupetta, _03C0
    GoTo _0397

_0374:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _038F
    ApplyMovement obj_T11R0802_jupetta, _03D8
    GoTo _0397

_038F:
    ApplyMovement obj_T11R0802_jupetta, _03D0

_0397:
    WaitMovement
    SetVar VAR_MAP_LOCAL_0x0A, 1
    ReleaseAll
    End

_03A3:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BANETTE
    Message msg_0541_T11R0802_00013
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
_03C0:
    FaceNorth
    EndMovement

    .balign 4, 0
_03C8:
    FaceSouth
    EndMovement

    .balign 4, 0
_03D0:
    FaceWest
    EndMovement

    .balign 4, 0
_03D8:
    FaceEast
    EndMovement

scr_seq_T11R0802_001:
    NPCMessage msg_0541_T11R0802_00015
    End

scr_seq_T11R0802_002:
    NPCMessage msg_0541_T11R0802_00014
    End

scr_seq_T11R0802_006:
    CheckFlag FLAG_RECEIVED_ROUTE_225_HOUSE_FRESH_WATER
    GoToIf 1, _0431
    CompareVar VAR_SPEAR_PILLAR_DISTORTED_STATE, 2
    GoToIf 1, _0433
    NPCMessage msg_0541_T11R0802_00016
    End

_0431:
    End

_0433:
    NPCMessage msg_0541_T11R0802_00017
    End

scr_seq_T11R0802_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0541_T11R0802_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
