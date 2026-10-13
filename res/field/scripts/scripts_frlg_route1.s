#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_route1.h"
#include "res/field/events/kanto_events_006_r01.h"

// FRLG's Route 1 on HGSS's.


    ScriptEntry Route1_MartClerk
    ScriptEntry Route1_Boy
    ScriptEntry Route1_RouteSign
    ScriptEntryEnd

Route1_MartClerk:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_GOT_POTION_ON_ROUTE_1, Route1_AlreadyGotPotion
    Message Route1_Text_WorkAtPokeMartTakeSample
    SetVar VAR_0x8004, ITEM_POTION
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, Route1_BagIsFull
    Common_GiveItemQuantity
    SetFlag FLAG_GOT_POTION_ON_ROUTE_1
    CloseMessage
    ReleaseAll
    End

Route1_BagIsFull:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

Route1_AlreadyGotPotion:
    Message Route1_Text_ComeSeeUsIfYouNeedPokeBalls
    WaitButton
    CloseMessage
    ReleaseAll
    End

Route1_Boy:
    NPCMessage Route1_Text_CanJumpFromLedges
    End

Route1_RouteSign:
    DrawSignpostInstantMessage Route1_Text_RouteSign, SIGNPOST_TYPE_ARROW, 4
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
