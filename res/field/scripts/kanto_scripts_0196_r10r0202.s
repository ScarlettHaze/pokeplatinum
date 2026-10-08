#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0345_r10r0202.h"
#include "res/field/events/kanto_events_441_r10r0202.h"


    ScriptEntry scr_seq_R10R0202_000
    ScriptEntry scr_seq_R10R0202_001
    ScriptEntry scr_seq_R10R0202_002
    ScriptEntry scr_seq_R10R0202_003
    ScriptEntry scr_seq_R10R0202_004
    ScriptEntry scr_seq_R10R0202_005_StandIn
    ScriptEntry scr_seq_R10R0202_006_StandIn
    ScriptEntry scr_seq_R10R0202_007
    ScriptEntry scr_seq_R10R0202_008
    ScriptEntry scr_seq_R10R0202_009
    ScriptEntryEnd

scr_seq_R10R0202_007:
    LockAll
    ApplyMovement obj_R10R0202_policeman, _0198
    ApplyMovement LOCALID_PLAYER, _01B4
    ApplyMovement obj_R10R0202_gsassistantm, _01CC
    WaitMovement
    Message msg_0345_R10R0202_00001
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _01D8
    ApplyMovement LOCALID_PLAYER, _01FC
    WaitMovement
    Message msg_0345_R10R0202_00002
    CloseMessage
    ApplyMovement obj_R10R0202_policeman, _01E8
    WaitMovement
    ClearFlag FLAG_RECEIVED_ROUTE_217_WEST_HOUSE_ICICLE_PLATE
    SetVar VAR_VEILSTONE_WAREHOUSE_GUARDS_FIGHTABLE, 0
    SetVar VAR_ROUTE_227_WAKE_RIVAL_STATE, 1
    ReleaseAll
    End

    .balign 4, 0
_0198:
    EmoteExclamationMark
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 3
    WalkNormalEast 5
    WalkNormalNorth 2
    EndMovement

    .balign 4, 0
_01B4:
    Delay32 2
    WalkNormalNorth
    FaceSouth
    Delay16
    FaceEast
    EndMovement

    .balign 4, 0
_01CC:
    Delay32 4
    FaceSouth
    EndMovement

    .balign 4, 0
_01D8:
    WalkNormalSouth 2
    WalkNormalWest 5
    FaceNorth
    EndMovement

    .balign 4, 0
_01E8:
    WalkNormalSouth 3
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement

    .balign 4, 0
_01FC:
    Delay8 7
    FaceSouth
    EndMovement

scr_seq_R10R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_NORTHEAST_HOUSE_BLUE_SCARF
    GoToIf 1, _0226
    Message msg_0345_R10R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0226:
    Message msg_0345_R10R0202_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R10R0202_003:
    NPCMessage msg_0345_R10R0202_00006
    End

scr_seq_R10R0202_001:
    NPCMessage msg_0345_R10R0202_00004
    End

scr_seq_R10R0202_002:
    NPCMessage msg_0345_R10R0202_00005
    End

scr_seq_R10R0202_004:
    NPCMessage msg_0345_R10R0202_00007
    End

scr_seq_R10R0202_008:
    NPCMessage msg_0345_R10R0202_00018
    End

scr_seq_R10R0202_009:
    NPCMessage msg_0345_R10R0202_00019
    End

scr_seq_R10R0202_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0345_R10R0202_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R10R0202_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0345_R10R0202_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
