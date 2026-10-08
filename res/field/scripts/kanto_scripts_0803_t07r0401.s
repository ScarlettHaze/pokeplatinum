#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0508_t07r0401.h"
#include "res/field/events/kanto_events_338_t07r0401.h"


    ScriptEntry scr_seq_T07R0401_000_StandIn
    ScriptEntry scr_seq_T07R0401_001
    ScriptEntry scr_seq_T07R0401_002
    ScriptEntry scr_seq_T07R0401_003
    ScriptEntry scr_seq_T07R0401_004
    ScriptEntry scr_seq_T07R0401_005_StandIn
    ScriptEntry scr_seq_T07R0401_006
    ScriptEntry scr_seq_T07R0401_007
    ScriptEntry scr_seq_T07R0401_008
    ScriptEntry scr_seq_T07R0401_009
    ScriptEntry scr_seq_T07R0401_010_StandIn
    ScriptEntry scr_seq_T07R0401_011_StandIn
    ScriptEntry scr_seq_T07R0401_012_StandIn
    ScriptEntry scr_seq_T07R0401_013_StandIn
    ScriptEntry scr_seq_T07R0401_014_StandIn
    ScriptEntry scr_seq_T07R0401_015_StandIn
    ScriptEntry scr_seq_T07R0401_016_StandIn
    ScriptEntry scr_seq_T07R0401_017_StandIn
    ScriptEntry scr_seq_T07R0401_018_StandIn
    ScriptEntry scr_seq_T07R0401_019_StandIn
    ScriptEntry scr_seq_T07R0401_020_StandIn
    ScriptEntry scr_seq_T07R0401_021_StandIn
    ScriptEntry scr_seq_T07R0401_022_StandIn
    ScriptEntry scr_seq_T07R0401_023_StandIn
    ScriptEntryEnd

scr_seq_T07R0401_001:
    NPCMessage msg_0508_T07R0401_00007
    End

scr_seq_T07R0401_002:
    NPCMessage msg_0508_T07R0401_00008
    End

scr_seq_T07R0401_003:
    NPCMessage msg_0508_T07R0401_00009
    End

scr_seq_T07R0401_004:
    NPCMessage msg_0508_T07R0401_00010
    End

scr_seq_T07R0401_006:
    NPCMessage msg_0508_T07R0401_00016
    End

scr_seq_T07R0401_007:
    NPCMessage msg_0508_T07R0401_00017
    End

scr_seq_T07R0401_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0508_T07R0401_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0508_T07R0401_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0508_T07R0401_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0508_T07R0401_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_010_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_011_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_012_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_013_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_014_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_015_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_016_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_017_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_018_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_019_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_020_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_021_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_022_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0401_023_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
