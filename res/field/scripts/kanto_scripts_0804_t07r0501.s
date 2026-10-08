#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0509_t07r0501.h"
#include "res/field/events/kanto_events_339_t07r0501.h"


    ScriptEntry scr_seq_T07R0501_000
    ScriptEntry scr_seq_T07R0501_001
    ScriptEntry scr_seq_T07R0501_002_StandIn
    ScriptEntry scr_seq_T07R0501_003_StandIn
    ScriptEntry scr_seq_T07R0501_004_StandIn
    ScriptEntryEnd

scr_seq_T07R0501_000:
    NPCMessage msg_0509_T07R0501_00000
    End

scr_seq_T07R0501_001:
    NPCMessage msg_0509_T07R0501_00001
    End

scr_seq_T07R0501_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0509_T07R0501_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0501_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0509_T07R0501_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0501_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0509_T07R0501_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
