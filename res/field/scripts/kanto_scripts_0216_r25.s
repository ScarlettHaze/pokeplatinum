#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0363_r25.h"
#include "res/field/events/kanto_events_026_r25.h"


    ScriptEntry scr_seq_R25_000
    ScriptEntry scr_seq_R25_001_StandIn
    ScriptEntry scr_seq_R25_002
    ScriptEntry scr_seq_R25_003_StandIn
    ScriptEntry scr_seq_R25_004_StandIn
    ScriptEntry scr_seq_R25_005
    ScriptEntry scr_seq_R25_006
    ScriptEntry scr_seq_R25_007_StandIn
    ScriptEntry scr_seq_R25_008
    ScriptEntry scr_seq_R25_009_StandIn
    ScriptEntryEnd

scr_seq_R25_008:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _012E
    End

_012E:
    SetFlag FLAG_UNK_0x005F
    RemoveObject obj_R25_tsure_poke_static_suicune
    ClearFlag FLAG_UNUSED_0x0122
    End

scr_seq_R25_000:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    AddVar VAR_MAP_LOCAL_0x00, 672
    AddVar VAR_MAP_LOCAL_0x01, 0
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _0171
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02B0
    ApplyMovement LOCALID_PLAYER, _0304
    GoTo _01B4

_0171:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _019C
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02CC
    ApplyMovement LOCALID_PLAYER, _0304
    GoTo _01B4

_019C:
    ApplyMovement obj_R25_gsleader11, _029C
    ApplyMovement obj_R25_gsman1, _02E8
    ApplyMovement LOCALID_PLAYER, _0310

_01B4:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _01E1
    ApplyMovement obj_R25_gsleader11, _032C
    ApplyMovement LOCALID_PLAYER, _0350
    GoTo _0214

_01E1:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _0204
    ApplyMovement obj_R25_gsleader11, _0338
    ApplyMovement LOCALID_PLAYER, _0350
    GoTo _0214

_0204:
    ApplyMovement obj_R25_gsleader11, _0344
    ApplyMovement LOCALID_PLAYER, _0350

_0214:
    WaitMovement
    Message msg_0363_R25_00000
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 40
    GoToIf 5, _023E
    ApplyMovement obj_R25_gsleader11, _035C
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _0271

_023E:
    CompareVar VAR_MAP_LOCAL_0x01, 41
    GoToIf 5, _0261
    ApplyMovement obj_R25_gsleader11, _0368
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _0271

_0261:
    ApplyMovement obj_R25_gsleader11, _0374
    ApplyMovement LOCALID_PLAYER, _0394

_0271:
    WaitMovement
    RemoveObject obj_R25_gsman1
    RemoveObject obj_R25_gsleader11
    SetFlag FLAG_UNK_0x005D
    SetFlag FLAG_UNK_0x005C
    ClearFlag FLAG_TALKED_TO_STARK_MOUNTAIN_ROOM_2_BUCK
    SetVar VAR_ROCK_PEAK_RUINS_STATE, 2
    ReleaseAll
    End

    .balign 4, 0
_029C:
    Delay8
    FaceWest
    Delay32 2
    FaceNorth
    EndMovement

    .balign 4, 0
_02B0:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement

    .balign 4, 0
_02CC:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 5
    WalkFastWest 5
    WalkFastSouth 8
    EndMovement

    .balign 4, 0
_02E8:
    Delay32
    FaceNorth
    EmoteExclamationMark
    WalkFastNorth 6
    WalkFastWest 5
    WalkFastSouth 9
    EndMovement

    .balign 4, 0
_0304:
    Delay16 6
    FaceSouth
    EndMovement

    .balign 4, 0
_0310:
    Delay16 6
    FaceNorth
    Delay8
    FaceWest
    Delay8
    FaceSouth
    EndMovement

    .balign 4, 0
_032C:
    WalkNormalNorth 7
    WalkNormalWest 2
    EndMovement

    .balign 4, 0
_0338:
    WalkNormalNorth 6
    WalkNormalWest 2
    EndMovement

    .balign 4, 0
_0344:
    WalkNormalNorth 5
    WalkNormalWest 2
    EndMovement

    .balign 4, 0
_0350:
    Delay16 3
    FaceEast
    EndMovement

    .balign 4, 0
_035C:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement

    .balign 4, 0
_0368:
    WalkNormalSouth
    WalkNormalWest 11
    EndMovement

    .balign 4, 0
_0374:
    WalkNormalNorth
    WalkNormalWest 11
    EndMovement

    .balign 4, 0
_0380:
    Delay8
    FaceSouth
    Delay8
    FaceWest
    EndMovement

    .balign 4, 0
_0394:
    Delay8
    FaceNorth
    Delay4
    FaceWest
    EndMovement

scr_seq_R25_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R25_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0363_R25_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R25_002:
    ShowLandmarkSign msg_0363_R25_00015
    End

scr_seq_R25_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0363_R25_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R25_003_StandIn:
    End

scr_seq_R25_004_StandIn:
    End

scr_seq_R25_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0363_R25_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R25_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0363_R25_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
