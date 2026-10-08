#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0482_t05r0701.h"
#include "res/field/events/kanto_events_394_t05r0701.h"


    ScriptEntry scr_seq_T05R0701_000
    ScriptEntry scr_seq_T05R0701_001
    ScriptEntry scr_seq_T05R0701_002
    ScriptEntry scr_seq_T05R0701_003_StandIn
    ScriptEntry scr_seq_T05R0701_004
    ScriptEntry scr_seq_T05R0701_005
    ScriptEntry scr_seq_T05R0701_006
    ScriptEntryEnd

scr_seq_T05R0701_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_SAVED_GAME_CORNER_TM64
    GoToIf 1, _0092
    Message msg_0482_T05R0701_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0092:
    Message msg_0482_T05R0701_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T05R0701_000:
    NPCMessage msg_0482_T05R0701_00000
    End

scr_seq_T05R0701_001:
    NPCMessage msg_0482_T05R0701_00001
    End

scr_seq_T05R0701_002:
    NPCMessage msg_0482_T05R0701_00002
    End

scr_seq_T05R0701_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0482_T05R0701_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T05R0701_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0482_T05R0701_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T05R0701_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0482_T05R0701_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
