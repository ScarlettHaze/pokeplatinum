#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0047_d01r0101.h"
#include "res/field/events/kanto_events_103_d01r0101.h"


    ScriptEntry scr_seq_D01R0101_000_StandIn
    ScriptEntry scr_seq_D01R0101_001_StandIn
    ScriptEntry scr_seq_D01R0101_002
    ScriptEntryEnd

scr_seq_D01R0101_002:
    NPCMessage msg_0047_D01R0101_00000
    End

scr_seq_D01R0101_000_StandIn:
    End

scr_seq_D01R0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0047_D01R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
