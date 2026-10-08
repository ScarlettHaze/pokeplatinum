#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0485_t06gym0101.h"
#include "res/field/events/kanto_events_322_t06gym0101.h"


    ScriptEntry scr_seq_T06GYM0101_000_StandIn
    ScriptEntry scr_seq_T06GYM0101_001_StandIn
    ScriptEntry scr_seq_T06GYM0101_002_StandIn
    ScriptEntry scr_seq_T06GYM0101_003_StandIn
    ScriptEntry scr_seq_T06GYM0101_004_StandIn
    ScriptEntry scr_seq_T06GYM0101_005_StandIn
    ScriptEntry scr_seq_T06GYM0101_006_StandIn
    ScriptEntry scr_seq_T06GYM0101_007_StandIn
    ScriptEntry scr_seq_T06GYM0101_008_StandIn
    ScriptEntry scr_seq_T06GYM0101_009_StandIn
    ScriptEntry scr_seq_T06GYM0101_010_StandIn
    ScriptEntry scr_seq_T06GYM0101_011_StandIn
    ScriptEntry scr_seq_T06GYM0101_012_StandIn
    ScriptEntry scr_seq_T06GYM0101_013_StandIn
    ScriptEntry scr_seq_T06GYM0101_014_StandIn
    ScriptEntry scr_seq_T06GYM0101_015
    ScriptEntry scr_seq_T06GYM0101_016
    ScriptEntry scr_seq_T06GYM0101_017
    ScriptEntry scr_seq_T06GYM0101_018
    ScriptEntry scr_seq_T06GYM0101_019
    ScriptEntry scr_seq_T06GYM0101_020
    ScriptEntry scr_seq_T06GYM0101_021_StandIn
    ScriptEntry scr_seq_T06GYM0101_022
    ScriptEntry scr_seq_T06GYM0101_023_StandIn
    ScriptEntry scr_seq_T06GYM0101_024
    ScriptEntry scr_seq_T06GYM0101_025
    ScriptEntryEnd

scr_seq_T06GYM0101_022:
    CheckFlag FLAG_DEFEATED_LUCIAN
    GoToIf 1, _0175
    ShowObject obj_T06GYM0101_stop
    ShowObject obj_T06GYM0101_stop_2
    ShowObject obj_T06GYM0101_stop_3
    ShowObject obj_T06GYM0101_stop_4
    ShowObject obj_T06GYM0101_stop_5
    ShowObject obj_T06GYM0101_stop_6
    End

_0175:
    End

scr_seq_T06GYM0101_015:
    End

scr_seq_T06GYM0101_016:
    End

scr_seq_T06GYM0101_017:
    End

scr_seq_T06GYM0101_018:
    End

scr_seq_T06GYM0101_019:
    End

scr_seq_T06GYM0101_020:
    End

scr_seq_T06GYM0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 2, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0409
    Message msg_0485_T06GYM0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0409:
    Message msg_0485_T06GYM0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_025:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 2, VAR_RESULT
    BufferPlayerName 0
    CompareVar VAR_RESULT, 0
    GoToIf 5, _043B
    Message msg_0485_T06GYM0101_00013
    GoTo _043E

_043B:
    Message msg_0485_T06GYM0101_00014

_043E:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_008_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_010_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_011_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_012_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_013_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_014_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06GYM0101_021_StandIn:
    End

scr_seq_T06GYM0101_023_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0485_T06GYM0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
