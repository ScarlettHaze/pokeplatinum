#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0326_r03.h"
#include "res/field/events/kanto_events_008_r03.h"


    ScriptEntry scr_seq_R03_000
    ScriptEntry scr_seq_R03_001_StandIn
    ScriptEntry scr_seq_R03_002_StandIn
    ScriptEntry scr_seq_R03_003_StandIn
    ScriptEntry scr_seq_R03_004_StandIn
    ScriptEntryEnd

scr_seq_R03_000:
    ShowLandmarkSign msg_0326_R03_00000
    End

scr_seq_R03_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0326_R03_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R03_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0326_R03_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R03_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0326_R03_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R03_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0326_R03_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
