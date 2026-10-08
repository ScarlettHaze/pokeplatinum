#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0362_r24.h"
#include "res/field/events/kanto_events_025_r24.h"


    ScriptEntry scr_seq_R24_000
    ScriptEntry scr_seq_R24_001
    ScriptEntry scr_seq_R24_002_StandIn
    ScriptEntry scr_seq_R24_003
    ScriptEntry scr_seq_R24_004
    ScriptEntryEnd

scr_seq_R24_004:
    CompareVar VAR_ICEBERG_RUINS_STATE, 2
    GoToIf 1, _0025
    End

_0025:
    SetVar VAR_ICEBERG_RUINS_STATE, 1
    End

scr_seq_R24_003:
    LockAll
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0060
    ApplyMovement obj_R24_rocketm, _0084
    ApplyMovement obj_R24_gsman1, _00A0
    ApplyMovement obj_R24_gswoman2, _00AC
    GoTo _0078

_0060:
    ApplyMovement obj_R24_rocketm, _0090
    ApplyMovement obj_R24_gsman1, _00A0
    ApplyMovement obj_R24_gswoman2, _00AC

_0078:
    WaitMovement
    SetVar VAR_ICEBERG_RUINS_STATE, 2
    ReleaseAll
    End

    .balign 4, 0
_0084:
    EmoteExclamationMark
    WalkFastWest 3
    EndMovement

    .balign 4, 0
_0090:
    FaceNorth
    EmoteExclamationMark
    WalkFastWest 3
    EndMovement

    .balign 4, 0
_00A0:
    Delay16 3
    FaceSouth
    EndMovement

    .balign 4, 0
_00AC:
    Delay16 3
    WalkFastSouth
    FaceNorth
    EndMovement

scr_seq_R24_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_ICEBERG_RUINS_STATE, 2
    GoToIf 5, _01B3
    GoTo _01DC

_01B3:
    CompareVar VAR_ICEBERG_RUINS_STATE, 3
    GoToIf 5, _01D1
    FacePlayer
    Message msg_0362_R24_00005
    GoTo _01DF

_01D1:
    FacePlayer
    Message msg_0362_R24_00006
    GoTo _01DF

_01DC:
    Message msg_0362_R24_00004

_01DF:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R24_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CompareVar VAR_ICEBERG_RUINS_STATE, 2
    GoToIf 5, _0206
    GoTo _022F

_0206:
    CompareVar VAR_ICEBERG_RUINS_STATE, 3
    GoToIf 5, _0224
    FacePlayer
    Message msg_0362_R24_00008
    GoTo _0232

_0224:
    FacePlayer
    Message msg_0362_R24_00009
    GoTo _0232

_022F:
    Message msg_0362_R24_00007

_0232:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R24_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0362_R24_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
