#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0454_t02gym0101.h"
#include "res/field/events/kanto_events_448_t02gym0101.h"


    ScriptEntry scr_seq_T02GYM0101_000_StandIn
    ScriptEntry scr_seq_T02GYM0101_001_StandIn
    ScriptEntry scr_seq_T02GYM0101_002_StandIn
    ScriptEntry scr_seq_T02GYM0101_003_StandIn
    ScriptEntry scr_seq_T02GYM0101_004
    ScriptEntryEnd

scr_seq_T02GYM0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 7, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04A7
    Message msg_0454_T02GYM0101_00009
    GoTo _04AA

_04A7:
    Message msg_0454_T02GYM0101_00010

_04AA:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T02GYM0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T02GYM0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0454_T02GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T02GYM0101_002_StandIn:
    End

scr_seq_T02GYM0101_003_StandIn:
    End

    .balign 4, 0
