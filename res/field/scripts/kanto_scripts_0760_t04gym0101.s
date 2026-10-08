#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0469_t04gym0101.h"
#include "res/field/events/kanto_events_382_t04gym0101.h"


    ScriptEntry scr_seq_T04GYM0101_000_StandIn
    ScriptEntry scr_seq_T04GYM0101_001
    ScriptEntry scr_seq_T04GYM0101_002
    ScriptEntry scr_seq_T04GYM0101_003
    ScriptEntry scr_seq_T04GYM0101_004
    ScriptEntry scr_seq_T04GYM0101_005_StandIn
    ScriptEntry scr_seq_T04GYM0101_006_StandIn
    ScriptEntry scr_seq_T04GYM0101_007_StandIn
    ScriptEntryEnd

scr_seq_T04GYM0101_004:
    LockAll
    ApplyMovement obj_T04GYM0101_rocketm, _01C8
    WaitMovement
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    Message msg_0469_T04GYM0101_00000
    ApplyMovement obj_T04GYM0101_rocketm, _01D0
    WaitMovement
    Message msg_0469_T04GYM0101_00001
    ApplyMovement obj_T04GYM0101_rocketm, _01E4
    WaitMovement
    Message msg_0469_T04GYM0101_00002
    ApplyMovement obj_T04GYM0101_rocketm, _01F4
    WaitMovement
    Message msg_0469_T04GYM0101_00003
    CloseMessage
    SetVar VAR_RESULT, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0179
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0159
    End

_0159:
    ApplyMovement obj_T04GYM0101_rocketm, _01FC
    ApplyMovement LOCALID_PLAYER, _0204
    WaitMovement
    GoTo _018B

_0179:
    ApplyMovement obj_T04GYM0101_rocketm, _01FC
    ApplyMovement LOCALID_PLAYER, _0204
    WaitMovement

_018B:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T04GYM0101_rocketm
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_RECEIVED_ROUTE_217_WEST_HOUSE_ICICLE_PLATE
    ClearFlag FLAG_UNK_0x005B
    ClearFlag FLAG_UNK_0x005C
    ClearFlag FLAG_UNK_0x005D
    SetVar VAR_ROUTE_227_WAKE_RIVAL_STATE, 2
    SetVar VAR_ICEBERG_RUINS_STATE, 1
    SetVar VAR_ROCK_PEAK_RUINS_STATE, 1
    ReleaseAll
    End

    .balign 4, 0
_01C8:
    WalkFasterSouth 5
    EndMovement

    .balign 4, 0
_01D0:
    LockDir
    JumpFarNorth
    Delay8 2
    WalkFastSouth 2
    EndMovement

    .balign 4, 0
_01E4:
    EmoteExclamationMark
    LockDir
    WalkNormalNorth 2
    EndMovement

    .balign 4, 0
_01F4:
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
_01FC:
    WalkFastSouth
    EndMovement

    .balign 4, 0
_0204:
    WalkFastWest
    FaceEast
    EndMovement

    .balign 4, 0
_0210:
    WalkFastWest
    EndMovement

scr_seq_T04GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_ROCK_PEAK_RUINS_STATE, 2
    GoToIf 5, _03AD
    CheckBadgeAcquired 1, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03A4
    Message msg_0469_T04GYM0101_00006
    GoTo _03A7

_03A4:
    Message msg_0469_T04GYM0101_00007

_03A7:
    GoTo _03F6

_03AD:
    Message msg_0469_T04GYM0101_00004
    GoTo _03F6

scr_seq_T04GYM0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_ROCK_PEAK_RUINS_STATE, 2
    GoToIf 5, _03F3
    CheckBadgeAcquired 1, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03EA
    Message msg_0469_T04GYM0101_00006
    GoTo _03ED

_03EA:
    Message msg_0469_T04GYM0101_00007

_03ED:
    GoTo _03F6

_03F3:
    Message msg_0469_T04GYM0101_00005

_03F6:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0424
    Message msg_0469_T04GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0424:
    Message msg_0469_T04GYM0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04GYM0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04GYM0101_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0469_T04GYM0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T04GYM0101_006_StandIn:
    End

scr_seq_T04GYM0101_007_StandIn:
    End

    .balign 4, 0
