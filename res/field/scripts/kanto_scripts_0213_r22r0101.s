#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0361_r22r0101.h"
#include "res/field/events/kanto_events_270_r22r0101.h"


    ScriptEntry scr_seq_R22R0101_000
    ScriptEntry scr_seq_R22R0101_001
    ScriptEntry scr_seq_R22R0101_002
    ScriptEntry scr_seq_R22R0101_003
    ScriptEntry scr_seq_R22R0101_004
    ScriptEntry scr_seq_R22R0101_005
    ScriptEntry scr_seq_R22R0101_006
    ScriptEntry scr_seq_R22R0101_007_StandIn
    ScriptEntry scr_seq_R22R0101_008_StandIn
    ScriptEntryEnd

scr_seq_R22R0101_006:
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_GYM_STATUE
    GoToIf 0, _003D
    SetPosition obj_R22R0101_policeman_3, 15, 0, 8, DIR_SOUTH

_003D:
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_CUTE_CUP
    GoToIf 0, _0054
    SetPosition obj_R22R0101_policeman_2, 7, 0, 8, DIR_SOUTH

_0054:
    End

scr_seq_R22R0101_000:
    LockAll
    ApplyMovement obj_R22R0101_policeman, _015C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0164
    WaitMovement
    Message msg_0361_R22R0101_00000
    WaitButton
    CloseMessage
    SetVar VAR_CELESTIC_TOWN_STATE, 1
    ReleaseAll
    End

    .balign 4, 0
_015C:
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_0164:
    WalkOnSpotNormalWest
    EndMovement

scr_seq_R22R0101_003:
    NPCMessage msg_0361_R22R0101_00000
    End

scr_seq_R22R0101_001:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _01A4
    ApplyMovement obj_R22R0101_policeman_3, _0264
    GoTo _01AC

_01A4:
    ApplyMovement obj_R22R0101_policeman_3, _0270

_01AC:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _01C9
    ApplyMovement obj_R22R0101_policeman_3, _027C
    GoTo _01EC

_01C9:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _01E4
    ApplyMovement obj_R22R0101_policeman_3, _028C
    GoTo _01EC

_01E4:
    ApplyMovement obj_R22R0101_policeman_3, _029C

_01EC:
    WaitMovement
    Message msg_0361_R22R0101_00005
    CloseMessage
    ApplyMovement obj_R22R0101_policeman_3, _02AC
    ApplyMovement LOCALID_PLAYER, _02B4
    WaitMovement
    WaitTime 16, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _023A
    ApplyMovement obj_R22R0101_policeman_3, _02C4
    GoTo _025D

_023A:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0255
    ApplyMovement obj_R22R0101_policeman_3, _02D0
    GoTo _025D

_0255:
    ApplyMovement obj_R22R0101_policeman_3, _02DC

_025D:
    WaitMovement
    ReleaseAll
    End

    .balign 4, 0
_0264:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_0270:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_027C:
    WalkFastEast
    WalkFastNorth
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
_028C:
    WalkFastEast
    WalkFastSouth
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
_029C:
    WalkFastEast
    WalkFastSouth 2
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
_02AC:
    WalkNormalWest
    EndMovement

    .balign 4, 0
_02B4:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement

    .balign 4, 0
_02C4:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
_02D0:
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
_02DC:
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement

scr_seq_R22R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_GYM_STATUE
    GoToIf 1, _0306
    Message msg_0361_R22R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0306:
    Message msg_0361_R22R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R22R0101_002:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _0336
    ApplyMovement obj_R22R0101_policeman_2, _03F8
    GoTo _033E

_0336:
    ApplyMovement obj_R22R0101_policeman_2, _0404

_033E:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _035B
    ApplyMovement obj_R22R0101_policeman_2, _0410
    GoTo _037E

_035B:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0376
    ApplyMovement obj_R22R0101_policeman_2, _0420
    GoTo _037E

_0376:
    ApplyMovement obj_R22R0101_policeman_2, _0430

_037E:
    WaitMovement
    Message msg_0361_R22R0101_00002
    CloseMessage
    ApplyMovement obj_R22R0101_policeman_2, _0440
    ApplyMovement LOCALID_PLAYER, _0448
    WaitMovement
    WaitTime 16, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _03CC
    ApplyMovement obj_R22R0101_policeman_2, _0458
    GoTo _03EF

_03CC:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _03E7
    ApplyMovement obj_R22R0101_policeman_2, _0464
    GoTo _03EF

_03E7:
    ApplyMovement obj_R22R0101_policeman_2, _0470

_03EF:
    WaitMovement
    ReleaseAll
    End

    .balign 4, 0
_03F8:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_0404:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_0410:
    WalkFastWest
    WalkFastNorth
    WalkOnSpotFastEast
    EndMovement

    .balign 4, 0
_0420:
    WalkFastWest
    WalkFastSouth
    WalkOnSpotFastEast
    EndMovement

    .balign 4, 0
_0430:
    WalkFastWest
    WalkFastSouth 2
    WalkOnSpotFastEast
    EndMovement

    .balign 4, 0
_0440:
    WalkNormalEast
    EndMovement

    .balign 4, 0
_0448:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement

    .balign 4, 0
_0458:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement

    .balign 4, 0
_0464:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement

    .balign 4, 0
_0470:
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement

scr_seq_R22R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_CUTE_CUP
    GoToIf 1, _049A
    Message msg_0361_R22R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_049A:
    Message msg_0361_R22R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R22R0101_007_StandIn:
    End

scr_seq_R22R0101_008_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0361_R22R0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
