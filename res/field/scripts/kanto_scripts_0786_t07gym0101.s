#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0492_t07gym0101.h"
#include "res/field/events/kanto_events_352_t07gym0101.h"


    ScriptEntry scr_seq_T07GYM0101_000_StandIn
    ScriptEntry scr_seq_T07GYM0101_001
    ScriptEntry scr_seq_T07GYM0101_002_StandIn
    ScriptEntryEnd

scr_seq_T07GYM0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 3, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01F2
    Message msg_0492_T07GYM0101_00005
    GoTo _01F5

_01F2:
    Message msg_0492_T07GYM0101_00006

_01F5:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07GYM0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0492_T07GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07GYM0101_002_StandIn:
    End

    .balign 4, 0
