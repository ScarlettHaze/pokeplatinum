#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0322_r02r0201.h"
#include "res/field/events/kanto_events_372_r02r0201.h"


    ScriptEntry scr_seq_R02R0201_000
    ScriptEntryEnd

scr_seq_R02R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_POKEMON_MANSION_MAIDS_ROOM_SOOTHE_BELL
    GoToIf 1, _0045
    Message msg_0322_R02R0201_00000
    SetVar VAR_0x8004, ITEM_NUGGET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0050
    Common_GiveItemQuantity
    SetFlag FLAG_RECEIVED_POKEMON_MANSION_MAIDS_ROOM_SOOTHE_BELL

_0045:
    Message msg_0322_R02R0201_00002
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
