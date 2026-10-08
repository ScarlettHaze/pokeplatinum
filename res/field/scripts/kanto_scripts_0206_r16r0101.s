#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0355_r16r0101.h"
#include "res/field/events/kanto_events_371_r16r0101.h"


    ScriptEntry scr_seq_R16R0101_000
    ScriptEntry scr_seq_R16R0101_001_StandIn
    ScriptEntryEnd

scr_seq_R16R0101_000:
    NPCMessage msg_0355_R16R0101_00000
    End

scr_seq_R16R0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0355_R16R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
