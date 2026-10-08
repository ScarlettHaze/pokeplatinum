#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0128_d43r0103.h"
#include "res/field/events/kanto_events_172_d43r0103.h"


    ScriptEntry scr_seq_D43R0103_000_StandIn
    ScriptEntry scr_seq_D43R0103_001
    ScriptEntry scr_seq_D43R0103_002
    ScriptEntry scr_seq_D43R0103_003
    ScriptEntry scr_seq_D43R0103_004
    ScriptEntry scr_seq_D43R0103_005
    ScriptEntry scr_seq_D43R0103_006
    ScriptEntryEnd

scr_seq_D43R0103_001:
    End

scr_seq_D43R0103_002:
    SetVar VAR_MAP_LOCAL_0x00, 57
    SetVar VAR_MAP_LOCAL_0x01, 42
    GoTo _0278

scr_seq_D43R0103_003:
    SetVar VAR_MAP_LOCAL_0x00, 28
    SetVar VAR_MAP_LOCAL_0x01, 38
    GoTo _0278

scr_seq_D43R0103_004:
    SetVar VAR_MAP_LOCAL_0x00, 31
    SetVar VAR_MAP_LOCAL_0x01, 44
    GoTo _0278

scr_seq_D43R0103_005:
    SetVar VAR_MAP_LOCAL_0x00, 22
    SetVar VAR_MAP_LOCAL_0x01, 17
    GoTo _0278

scr_seq_D43R0103_006:
    SetVar VAR_MAP_LOCAL_0x00, 58
    SetVar VAR_MAP_LOCAL_0x01, 28
    GoTo _0278

_0278:
    LockAll
    SetVar VAR_ROUTE_224_STATE, 1
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02A9
    ApplyMovement LOCALID_PLAYER, _0330
    GoTo _02FF

_02A9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02CC
    ApplyMovement LOCALID_PLAYER, _034C
    GoTo _02FF

_02CC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02EF
    ApplyMovement LOCALID_PLAYER, _0384
    GoTo _02FF

_02EF:
    ApplyMovement LOCALID_PLAYER, _0368

_02FF:
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_KANTO_VICTORY_ROAD_2F, VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End

    .balign 4, 0
_0330:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement

    .balign 4, 0
_033C:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement

    .balign 4, 0
_034C:
    WalkOnSpotFasterSouth 4
    SetInvisible
    EndMovement

    .balign 4, 0
_0358:
    Delay4 3
    WalkFasterSouth
    SetInvisible
    EndMovement

    .balign 4, 0
_0368:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement

    .balign 4, 0
_0374:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement

    .balign 4, 0
_0384:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement

    .balign 4, 0
_0390:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement

scr_seq_D43R0103_000_StandIn:
    End

    .balign 4, 0
