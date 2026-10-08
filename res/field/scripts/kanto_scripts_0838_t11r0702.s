#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0538_t11r0702.h"
#include "res/field/events/kanto_events_360_t11r0702.h"


    ScriptEntry scr_seq_T11R0702_000
    ScriptEntry scr_seq_T11R0702_001_StandIn
    ScriptEntry scr_seq_T11R0702_002_StandIn
    ScriptEntry scr_seq_T11R0702_003_StandIn
    ScriptEntry scr_seq_T11R0702_004_StandIn
    ScriptEntry scr_seq_T11R0702_005_StandIn
    ScriptEntry scr_seq_T11R0702_006_StandIn
    ScriptEntry scr_seq_T11R0702_007_StandIn
    ScriptEntryEnd

scr_seq_T11R0702_000:
    NPCMessage msg_0538_T11R0702_00035
    End

scr_seq_T11R0702_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0702_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0702_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0702_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0702_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0702_006_StandIn:
    End

scr_seq_T11R0702_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0538_T11R0702_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
