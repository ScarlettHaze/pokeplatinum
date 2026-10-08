#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0344_r10r0201.h"
#include "res/field/events/kanto_events_421_r10r0201.h"


    ScriptEntry scr_seq_R10R0201_000
    ScriptEntry scr_seq_R10R0201_001
    ScriptEntry scr_seq_R10R0201_002
    ScriptEntry scr_seq_R10R0201_003
    ScriptEntry scr_seq_R10R0201_004
    ScriptEntry scr_seq_R10R0201_005
    ScriptEntry scr_seq_R10R0201_006_StandIn
    ScriptEntry scr_seq_R10R0201_007
    ScriptEntry scr_seq_R10R0201_008
    ScriptEntryEnd

scr_seq_R10R0201_000:
    NPCMessage msg_0344_R10R0201_00003
    End

scr_seq_R10R0201_001:
    NPCMessage msg_0344_R10R0201_00004
    End

scr_seq_R10R0201_002:
    NPCMessage msg_0344_R10R0201_00005
    End

scr_seq_R10R0201_003:
    NPCMessage msg_0344_R10R0201_00006
    End

scr_seq_R10R0201_004:
    NPCMessage msg_0344_R10R0201_00007
    End

scr_seq_R10R0201_005:
    NPCMessage msg_0344_R10R0201_00008
    End

scr_seq_R10R0201_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R10R0201_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R10R0201_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0344_R10R0201_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
