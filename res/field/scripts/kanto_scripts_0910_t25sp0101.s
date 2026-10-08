#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0603_t25sp0101.h"
#include "res/field/events/kanto_events_488_t25sp0101.h"


    ScriptEntry scr_seq_T25SP0101_000_StandIn
    ScriptEntry scr_seq_T25SP0101_001
    ScriptEntry scr_seq_T25SP0101_002
    ScriptEntry scr_seq_T25SP0101_003_StandIn
    ScriptEntry scr_seq_T25SP0101_004_StandIn
    ScriptEntryEnd

    .balign 4, 0
_0080:
    FaceSouth
    EndMovement

    .balign 4, 0
_0088:
    FaceWest
    EndMovement

    .balign 4, 0
_0090:
    FaceEast
    EndMovement

scr_seq_T25SP0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _00BD
    Call _00F0
    GoTo _00C5

_00BD:
    ApplyMovement obj_T25SP0101_suit, _0080

_00C5:
    WaitMovement
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E5
    Message msg_0603_T25SP0101_00041
    GoTo _00E8

_00E5:
    Message msg_0603_T25SP0101_00039

_00E8:
    WaitButton
    CloseMessage
    ReleaseAll
    End

_00F0:
    GetPlayerMapPos VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x02, 6
    GoToIf 5, _0111
    ApplyMovement obj_T25SP0101_suit, _0088
    GoTo _0119

_0111:
    ApplyMovement obj_T25SP0101_suit, _0090

_0119:
    Return

scr_seq_T25SP0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0175
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0154
    Message msg_0603_T25SP0101_00034
    SetVar VAR_MAP_LOCAL_0x01, 1
    GoTo _016D

_0154:
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _016A
    Message msg_0603_T25SP0101_00035
    GoTo _016D

_016A:
    Message msg_0603_T25SP0101_00036

_016D:
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0175:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _018B
    Message msg_0603_T25SP0101_00028
    GoTo _018E

_018B:
    Message msg_0603_T25SP0101_00037

_018E:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C5
    Message msg_0603_T25SP0101_00031
    SetVar VAR_MAP_LOCAL_0x01, 1
    SetVar VAR_0x8004, ITEM_COIN_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0603_T25SP0101_00032
    GoTo _00E8

_01C5:
    SetVar VAR_MAP_LOCAL_0x01, 1
    Message msg_0603_T25SP0101_00033
    GoTo _00E8

scr_seq_T25SP0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0603_T25SP0101_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T25SP0101_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0603_T25SP0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T25SP0101_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0603_T25SP0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
