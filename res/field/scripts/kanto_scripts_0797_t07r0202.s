#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0502_t07r0202.h"
#include "res/field/events/kanto_events_334_t07r0202.h"


    ScriptEntry scr_seq_T07R0202_000
    ScriptEntry scr_seq_T07R0202_001
    ScriptEntry scr_seq_T07R0202_002
    ScriptEntryEnd

scr_seq_T07R0202_001:
    SetVar VAR_ROUTE_217_STATE, 0
    End

scr_seq_T07R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0502_T07R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0202_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0502_T07R0202_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
