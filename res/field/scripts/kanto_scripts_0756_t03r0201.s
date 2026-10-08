#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0465_t03r0201.h"
#include "res/field/events/kanto_events_425_t03r0201.h"


    ScriptEntry scr_seq_T03R0201_000
    ScriptEntry scr_seq_T03R0201_001
    ScriptEntryEnd

scr_seq_T03R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0465_T03R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_NIDORAN_M
    Message msg_0465_T03R0201_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
