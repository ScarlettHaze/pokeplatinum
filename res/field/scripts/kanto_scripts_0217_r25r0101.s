#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0364_r25r0101.h"
#include "res/field/events/kanto_events_395_r25r0101.h"


    ScriptEntry scr_seq_R25R0101_000_StandIn
    ScriptEntryEnd

scr_seq_R25R0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0364_R25R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
