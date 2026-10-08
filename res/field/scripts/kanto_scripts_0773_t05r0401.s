#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0480_t05r0401.h"
#include "res/field/events/kanto_events_392_t05r0401.h"


    ScriptEntry scr_seq_T05R0401_000_StandIn
    ScriptEntryEnd

scr_seq_T05R0401_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0480_T05R0401_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
