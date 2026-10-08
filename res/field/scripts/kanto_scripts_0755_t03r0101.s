#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0464_t03r0101.h"
#include "res/field/events/kanto_events_424_t03r0101.h"


    ScriptEntry scr_seq_T03R0101_000
    ScriptEntry scr_seq_T03R0101_001_StandIn
    ScriptEntry scr_seq_T03R0101_002
    ScriptEntry scr_seq_T03R0101_003
    ScriptEntry scr_seq_T03R0101_004
    ScriptEntry scr_seq_T03R0101_005
    ScriptEntry scr_seq_T03R0101_006
    ScriptEntry scr_seq_T03R0101_007
    ScriptEntry scr_seq_T03R0101_008
    ScriptEntry scr_seq_T03R0101_009
    ScriptEntry scr_seq_T03R0101_010
    ScriptEntry scr_seq_T03R0101_011
    ScriptEntry scr_seq_T03R0101_012
    ScriptEntry scr_seq_T03R0101_013_StandIn
    ScriptEntry scr_seq_T03R0101_014_StandIn
    ScriptEntry scr_seq_T03R0101_015
    ScriptEntry scr_seq_T03R0101_016_StandIn
    ScriptEntry scr_seq_T03R0101_017
    ScriptEntry scr_seq_T03R0101_018_StandIn
    ScriptEntry scr_seq_T03R0101_019
    ScriptEntryEnd

scr_seq_T03R0101_017:
    End

scr_seq_T03R0101_000:
    NPCMessage msg_0464_T03R0101_00000
    End

scr_seq_T03R0101_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00013
    WaitButton
    CloseMessage
    SetVar VAR_RIVAL_HOUSE_STATE, 5
    ReleaseAll
    End

scr_seq_T03R0101_015:
    End

scr_seq_T03R0101_002:
    NPCMessage msg_0464_T03R0101_00010
    End

scr_seq_T03R0101_003:
    NPCMessage msg_0464_T03R0101_00011
    End

scr_seq_T03R0101_004:
    NPCMessage msg_0464_T03R0101_00012
    End

scr_seq_T03R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0464_T03R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03R0101_013_StandIn:
    End

scr_seq_T03R0101_014_StandIn:
    End

scr_seq_T03R0101_016_StandIn:
    End

scr_seq_T03R0101_018_StandIn:
    End

    .balign 4, 0
