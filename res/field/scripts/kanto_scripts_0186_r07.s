#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0336_r07.h"
#include "res/field/events/kanto_events_012_r07.h"


    ScriptEntry scr_seq_R07_000
    ScriptEntry scr_seq_R07_001
    ScriptEntryEnd

scr_seq_R07_000:
    ShowLandmarkSign msg_0336_R07_00000
    End

scr_seq_R07_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0336_R07_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
