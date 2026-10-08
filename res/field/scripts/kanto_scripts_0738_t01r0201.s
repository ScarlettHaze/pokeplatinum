#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0449_t01r0201.h"
#include "res/field/events/kanto_events_456_t01r0201.h"


    ScriptEntry scr_seq_T01R0201_000_StandIn
    ScriptEntryEnd

scr_seq_T01R0201_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0449_T01R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
