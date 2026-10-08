#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0450_t01r0202.h"
#include "res/field/events/kanto_events_459_t01r0202.h"


    ScriptEntry scr_seq_T01R0202_000
    ScriptEntry scr_seq_T01R0202_001
    ScriptEntryEnd

scr_seq_T01R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0450_T01R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0202_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0450_T01R0202_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
