#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0258_p01r0104.h"
#include "res/field/events/kanto_events_344_p01r0104.h"


    ScriptEntry scr_seq_P01R0104_000_StandIn
    ScriptEntry scr_seq_P01R0104_001
    ScriptEntry scr_seq_P01R0104_002
    ScriptEntry scr_seq_P01R0104_003_StandIn
    ScriptEntryEnd

scr_seq_P01R0104_002:
    CompareVar VAR_VALLEY_WINDWORKS_STATE, 1
    GoToIf 1, _0045
    End

_0045:
    SetPosition obj_P01R0104_seaman_2, 24, 0, 19, DIR_WEST
    End

scr_seq_P01R0104_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0090
    WaitMovement
    ApplyMovement obj_P01R0104_seaman_2, _0098
    WaitMovement
    SetVar VAR_VALLEY_WINDWORKS_STATE, 0
    ClearFlag FLAG_RECEIVED_FUEGO_IRONWORKS_BUILDING_STAR_PIECE
    ReleaseAll
    End

    .balign 4, 0
_0090:
    WalkNormalSouth 3
    EndMovement

    .balign 4, 0
_0098:
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement

scr_seq_P01R0104_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0258_P01R0104_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_P01R0104_003_StandIn:
    End

    .balign 4, 0
