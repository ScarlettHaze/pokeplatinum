#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0534_t11r0501.h"
#include "res/field/events/kanto_events_356_t11r0501.h"


    ScriptEntry scr_seq_T11R0501_000
    ScriptEntryEnd

scr_seq_T11R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_HIDE_LAKE_ACUITY_RIVAL
    GoToIf 1, _0045
    Message msg_0534_T11R0501_00000
    SetVar VAR_0x8004, ITEM_TM29
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0050
    Common_GiveItemQuantity
    SetFlag FLAG_HIDE_LAKE_ACUITY_RIVAL

_0045:
    Message msg_0534_T11R0501_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0050:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
