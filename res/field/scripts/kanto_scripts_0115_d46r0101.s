#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0132_d46r0101.h"
#include "res/field/events/kanto_events_143_d46r0101.h"


    ScriptEntry scr_seq_D46R0101_000_StandIn
    ScriptEntry scr_seq_D46R0101_001_StandIn
    ScriptEntryEnd

scr_seq_D46R0101_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0132_D46R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D46R0101_001_StandIn:
    End

    .balign 4, 0
