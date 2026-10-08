#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0505_t07r0205.h"
#include "res/field/events/kanto_events_337_t07r0205.h"


    ScriptEntry scr_seq_T07R0205_000
    ScriptEntryEnd

scr_seq_T07R0205_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_UNUSED_0x016F
    GoToIf 1, _0071
    Message msg_0505_T07R0205_00000
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0045
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0045
    Message msg_0505_T07R0205_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0045:
    Message msg_0505_T07R0205_00002
    SetVar VAR_0x8004, ITEM_SPELL_TAG
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _007C
    Common_GiveItemQuantity
    SetFlag FLAG_UNUSED_0x016F

_0071:
    Message msg_0505_T07R0205_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

_007C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
