#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0531_t11gym0101.h"
#include "res/field/events/kanto_events_366_t11gym0101.h"


    ScriptEntry scr_seq_T11GYM0101_000_StandIn
    ScriptEntry scr_seq_T11GYM0101_001
    ScriptEntry scr_seq_T11GYM0101_002
    ScriptEntry scr_seq_T11GYM0101_003_StandIn
    ScriptEntry scr_seq_T11GYM0101_004_StandIn
    ScriptEntryEnd

scr_seq_T11GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 5, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0182
    Message msg_0531_T11GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0182:
    Message msg_0531_T11GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 5, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B4
    Message msg_0531_T11GYM0101_00008
    GoTo _01B7

_01B4:
    Message msg_0531_T11GYM0101_00009

_01B7:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11GYM0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0531_T11GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11GYM0101_003_StandIn:
    End

scr_seq_T11GYM0101_004_StandIn:
    End

    .balign 4, 0
