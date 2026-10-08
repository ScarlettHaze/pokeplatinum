#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0514_t08gym0101.h"
#include "res/field/events/kanto_events_433_t08gym0101.h"


    ScriptEntry scr_seq_T08GYM0101_000_StandIn
    ScriptEntry scr_seq_T08GYM0101_001_StandIn
    ScriptEntry scr_seq_T08GYM0101_002
    ScriptEntry scr_seq_T08GYM0101_003_StandIn
    ScriptEntry scr_seq_T08GYM0101_004_StandIn
    ScriptEntry scr_seq_T08GYM0101_005_StandIn
    ScriptEntry scr_seq_T08GYM0101_006_StandIn
    ScriptEntry scr_seq_T08GYM0101_007
    ScriptEntry scr_seq_T08GYM0101_008_StandIn
    ScriptEntryEnd

scr_seq_T08GYM0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 4, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _07C4
    Message msg_0514_T08GYM0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End

_07C4:
    Message msg_0514_T08GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 4, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _07F6
    Message msg_0514_T08GYM0101_00017
    GoTo _07F9

_07F6:
    Message msg_0514_T08GYM0101_00018

_07F9:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_000_StandIn:
    End

scr_seq_T08GYM0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0514_T08GYM0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08GYM0101_008_StandIn:
    End

    .balign 4, 0
