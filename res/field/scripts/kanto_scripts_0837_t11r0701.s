#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0537_t11r0701.h"
#include "res/field/events/kanto_events_359_t11r0701.h"


    ScriptEntry scr_seq_T11R0701_000
    ScriptEntry scr_seq_T11R0701_001
    ScriptEntry scr_seq_T11R0701_002_StandIn
    ScriptEntry scr_seq_T11R0701_003
    ScriptEntry scr_seq_T11R0701_004_StandIn
    ScriptEntry scr_seq_T11R0701_005_StandIn
    ScriptEntryEnd

scr_seq_T11R0701_000:
    NPCMessage msg_0537_T11R0701_00000
    End

scr_seq_T11R0701_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_HIDE_LAKE_VERITY_TEAM_GALACTIC
    GoToIf 1, _015A
    Message msg_0537_T11R0701_00001
    SetVar VAR_0x8004, ITEM_UPGRADE
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0165
    Common_GiveItemQuantity
    SetFlag FLAG_HIDE_LAKE_VERITY_TEAM_GALACTIC

_015A:
    Message msg_0537_T11R0701_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0165:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0537_T11R0701_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0701_002_StandIn:
    End

scr_seq_T11R0701_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0537_T11R0701_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0701_005_StandIn:
    End

    .balign 4, 0
