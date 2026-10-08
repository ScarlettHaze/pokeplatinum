#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0503_t07r0203.h"
#include "res/field/events/kanto_events_335_t07r0203.h"


    ScriptEntry scr_seq_T07R0203_000_StandIn
    ScriptEntry scr_seq_T07R0203_001
    ScriptEntry scr_seq_T07R0203_002
    ScriptEntry scr_seq_T07R0203_003
    ScriptEntry scr_seq_T07R0203_004
    ScriptEntry scr_seq_T07R0203_005
    ScriptEntry scr_seq_T07R0203_006
    ScriptEntry scr_seq_T07R0203_007
    ScriptEntry scr_seq_T07R0203_008_StandIn
    ScriptEntry scr_seq_T07R0203_009_StandIn
    ScriptEntry scr_seq_T07R0203_010_StandIn
    ScriptEntry scr_seq_T07R0203_011
    ScriptEntry scr_seq_T07R0203_012
    ScriptEntry scr_seq_T07R0203_013
    ScriptEntryEnd

scr_seq_T07R0203_011:
    CompareVar VAR_MT_CORONET_2F_STATE, 0
    GoToIf 5, _006B
    SetPosition obj_T07R0203_var_1, 12, 0, 6, DIR_WEST
    SetPosition obj_T07R0203_tsure_poke_static_marill, 13, 0, 6, DIR_WEST

_006B:
    End

scr_seq_T07R0203_001:
    NPCMessage msg_0503_T07R0203_00004
    End

scr_seq_T07R0203_002:
    NPCMessage msg_0503_T07R0203_00005
    End

scr_seq_T07R0203_003:
    NPCMessage msg_0503_T07R0203_00006
    End

scr_seq_T07R0203_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_012:
    NPCMessage msg_0503_T07R0203_00021
    End

scr_seq_T07R0203_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0503_T07R0203_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_008_StandIn:
    End

scr_seq_T07R0203_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0503_T07R0203_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0203_010_StandIn:
    End

    .balign 4, 0
