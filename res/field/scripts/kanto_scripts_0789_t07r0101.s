#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0494_t07r0101.h"
#include "res/field/events/kanto_events_327_t07r0101.h"


    ScriptEntry scr_seq_T07R0101_000
    ScriptEntry scr_seq_T07R0101_001
    ScriptEntry scr_seq_T07R0101_002
    ScriptEntry scr_seq_T07R0101_003
    ScriptEntryEnd

scr_seq_T07R0101_000:
    NPCMessage msg_0494_T07R0101_00000
    End

scr_seq_T07R0101_001:
    NPCMessage msg_0494_T07R0101_00001
    End

scr_seq_T07R0101_002:
    NPCMessage msg_0494_T07R0101_00002
    End

scr_seq_T07R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0494_T07R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
