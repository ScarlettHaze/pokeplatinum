#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0052_d10r0101.h"
#include "res/field/events/kanto_events_106_d10r0101.h"


    ScriptEntry scr_seq_D10R0101_000_StandIn
    ScriptEntry scr_seq_D10R0101_001_StandIn
    ScriptEntry scr_seq_D10R0101_002_StandIn
    ScriptEntry scr_seq_D10R0101_003_StandIn
    ScriptEntry scr_seq_D10R0101_004_StandIn
    ScriptEntry scr_seq_D10R0101_005_StandIn
    ScriptEntryEnd

scr_seq_D10R0101_000_StandIn:
    End

scr_seq_D10R0101_001_StandIn:
    End

scr_seq_D10R0101_002_StandIn:
    End

scr_seq_D10R0101_003_StandIn:
    End

scr_seq_D10R0101_004_StandIn:
    End

scr_seq_D10R0101_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0052_D10R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
