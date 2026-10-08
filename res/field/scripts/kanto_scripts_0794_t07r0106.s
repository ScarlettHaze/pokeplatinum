#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0499_t07r0106.h"
#include "res/field/events/kanto_events_332_t07r0106.h"


    ScriptEntry scr_seq_T07R0106_000
    ScriptEntry scr_seq_T07R0106_001
    ScriptEntry scr_seq_T07R0106_002
    ScriptEntry scr_seq_T07R0106_003_StandIn
    ScriptEntryEnd

scr_seq_T07R0106_000:
    NPCMessage msg_0499_T07R0106_00000
    End

scr_seq_T07R0106_001:
    NPCMessage msg_0499_T07R0106_00001
    End

scr_seq_T07R0106_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0499_T07R0106_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0106_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0499_T07R0106_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
