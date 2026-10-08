#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0497_t07r0104.h"
#include "res/field/events/kanto_events_330_t07r0104.h"


    ScriptEntry scr_seq_T07R0104_000
    ScriptEntry scr_seq_T07R0104_001
    ScriptEntry scr_seq_T07R0104_002
    ScriptEntry scr_seq_T07R0104_003
    ScriptEntry scr_seq_T07R0104_004_StandIn
    ScriptEntry scr_seq_T07R0104_005_StandIn
    ScriptEntry scr_seq_T07R0104_006_StandIn
    ScriptEntryEnd

scr_seq_T07R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 21
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_21
    ReleaseAll
    End

scr_seq_T07R0104_001:
    NPCMessage msg_0497_T07R0104_00016
    End

scr_seq_T07R0104_002:
    NPCMessage msg_0497_T07R0104_00017
    End

scr_seq_T07R0104_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0497_T07R0104_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0104_004_StandIn:
    End

scr_seq_T07R0104_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0497_T07R0104_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0104_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0497_T07R0104_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
