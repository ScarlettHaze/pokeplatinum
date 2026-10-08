#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0257_p01r0103.h"
#include "res/field/events/kanto_events_343_p01r0103.h"


    ScriptEntry scr_seq_P01R0103_000
    ScriptEntry scr_seq_P01R0103_001_StandIn
    ScriptEntry scr_seq_P01R0103_002
    ScriptEntryEnd

scr_seq_P01R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _014D
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _0158
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _006C
    GoTo _00EF

_006C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0085
    GoTo _0142

_0085:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _009E
    GoTo _0142

_009E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00B7
    GoTo _00EF

_00B7:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _00D0
    GoTo _0142

_00D0:
    CompareVar VAR_RESULT, 5
    GoToIf 5, _00E9
    GoTo _0142

_00E9:
    GoTo _0142

_00EF:
    Message msg_0257_P01R0103_00000
    CloseMessage
    ApplyMovement obj_P01R0103_seaman_2, _0190
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01B0
    WaitMovement
    SetVar VAR_MAP_LOCAL_0x02, 1
    SetVar VAR_VALLEY_WINDWORKS_STATE, 2
    SetVar VAR_HALLOWED_TOWER_STATE, 0
    ClearFlag FLAG_SPEAR_PILLAR_IS_DISTORTED
    SetFlag FLAG_TALKED_TO_CANALAVE_CITY_SAILOR_ELDRITCH_HOUSE_LITTLE_BOY
    ClearFlag FLAG_RECEIVED_CELESTIC_TOWN_NORTHWEST_HOUSE_CHOICE_SPECS
    SetFlag FLAG_RECEIVED_CELESTIC_TOWN_NORTHWEST_HOUSE_BLACKGLASSES
    ReleaseAll
    End

_0142:
    Message msg_0257_P01R0103_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_014D:
    Message msg_0257_P01R0103_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0158:
    ApplyMovement obj_P01R0103_seaman_2, _01B8
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01D8
    WaitMovement
    ApplyMovement obj_P01R0103_seaman_2, _01E4
    WaitMovement
    ReleaseAll
    End

    .balign 4, 0
_0190:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement

    .balign 4, 0
_01B0:
    WalkNormalSouth 2
    EndMovement

    .balign 4, 0
_01B8:
    LockDir
    WalkNormalNorth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement

    .balign 4, 0
_01D8:
    Delay8
    WalkNormalNorth 4
    EndMovement

    .balign 4, 0
_01E4:
    WalkNormalWest
    FaceSouth 2
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement

scr_seq_P01R0103_002:
    NPCMessage msg_0257_P01R0103_00003
    End

scr_seq_P01R0103_001_StandIn:
    End

    .balign 4, 0
