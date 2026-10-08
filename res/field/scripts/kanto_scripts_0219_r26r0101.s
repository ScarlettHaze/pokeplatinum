#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0366_r26r0101.h"
#include "res/field/events/kanto_events_267_r26r0101.h"


    ScriptEntry scr_seq_R26R0101_000_StandIn
    ScriptEntry scr_seq_R26R0101_001
    ScriptEntryEnd

scr_seq_R26R0101_001:
    NPCMessage msg_0366_R26R0101_00002
    End

scr_seq_R26R0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0366_R26R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
