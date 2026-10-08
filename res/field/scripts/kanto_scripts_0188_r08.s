#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0338_r08.h"
#include "res/field/events/kanto_events_013_r08.h"


    ScriptEntry scr_seq_R08_000
    ScriptEntry scr_seq_R08_001
    ScriptEntryEnd

scr_seq_R08_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0338_R08_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R08_001:
    ShowLandmarkSign msg_0338_R08_00001
    End

    .balign 4, 0
