#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0331_r05r0202.h"
#include "res/field/events/kanto_events_484_r05r0202.h"


    ScriptEntry scr_seq_R05R0202_000_StandIn
    ScriptEntry scr_seq_R05R0202_001
    ScriptEntryEnd

scr_seq_R05R0202_001:
    SetVar VAR_MAP_LOCAL_0x00, 0
    End

scr_seq_R05R0202_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0331_R05R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
