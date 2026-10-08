#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0500_t07r0107.h"
#include "res/field/events/kanto_events_397_t07r0107.h"


    ScriptEntry scr_seq_T07R0107_000_StandIn
    ScriptEntryEnd

scr_seq_T07R0107_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0500_T07R0107_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
