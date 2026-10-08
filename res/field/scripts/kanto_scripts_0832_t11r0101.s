#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0533_t11r0101.h"
#include "res/field/events/kanto_events_355_t11r0101.h"


    ScriptEntry scr_seq_T11R0101_000
    ScriptEntry scr_seq_T11R0101_001
    ScriptEntry scr_seq_T11R0101_002
    ScriptEntry scr_seq_T11R0101_003_StandIn
    ScriptEntry scr_seq_T11R0101_004_StandIn
    ScriptEntry scr_seq_T11R0101_005_StandIn
    ScriptEntry scr_seq_T11R0101_006_StandIn
    ScriptEntry scr_seq_T11R0101_007_StandIn
    ScriptEntry scr_seq_T11R0101_008_StandIn
    ScriptEntry scr_seq_T11R0101_009_StandIn
    ScriptEntry scr_seq_T11R0101_010_StandIn
    ScriptEntry scr_seq_T11R0101_011_StandIn
    ScriptEntry scr_seq_T11R0101_012_StandIn
    ScriptEntry scr_seq_T11R0101_013_StandIn
    ScriptEntry scr_seq_T11R0101_014_StandIn
    ScriptEntry scr_seq_T11R0101_015_StandIn
    ScriptEntry scr_seq_T11R0101_016_StandIn
    ScriptEntry scr_seq_T11R0101_017_StandIn
    ScriptEntry scr_seq_T11R0101_018_StandIn
    ScriptEntry scr_seq_T11R0101_019_StandIn
    ScriptEntryEnd

scr_seq_T11R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_HIDE_ROUTE_210_SOUTH_PSYDUCK
    GoToIf 1, _08B2
    Message msg_0533_T11R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_08B2:
    Message msg_0533_T11R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_001:
    NPCMessage msg_0533_T11R0101_00002
    End

scr_seq_T11R0101_002:
    NPCMessage msg_0533_T11R0101_00003
    End

scr_seq_T11R0101_003_StandIn:
    End

scr_seq_T11R0101_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_008_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_010_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_011_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_012_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_013_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_014_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_015_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_016_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_017_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_018_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0101_019_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0533_T11R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
