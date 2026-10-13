#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_city_mart.h"
#include "res/field/events/kanto_events_452_t02fs0101.h"

// FRLG's Viridian City Mart on HGSS's. On the first visit the clerk hands
// over Oak's Parcel (Platinum's Parcel, renamed): the player walks from the
// door (4, 11) up to the counter at (4, 6), across from him.
//
// VAR_MAP_SCENE_VIRIDIAN_CITY_MART is FRLG's: 0 first visit, 1 carrying the
// parcel, 2 delivered.


    ScriptEntry ViridianCity_Mart_ParcelScene
    ScriptEntry ViridianCity_Mart_Clerk
    ScriptEntry ViridianCity_Mart_Woman
    ScriptEntry ViridianCity_Mart_Youngster
    ScriptEntryEnd

ViridianCity_Mart_ParcelScene:
    LockAll
    ApplyMovement LOCALID_CLERK, ViridianCity_Mart_Movement_FaceSouth
    WaitMovement
    Message ViridianCity_Mart_Text_YouCameFromPallet
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_CLERK, ViridianCity_Mart_Movement_ClerkFacePlayer
    ApplyMovement LOCALID_PLAYER, ViridianCity_Mart_Movement_ApproachCounter
    WaitMovement
    Message ViridianCity_Mart_Text_TakeThisToProfOak
    WaitButton
    SetVar VAR_MAP_SCENE_VIRIDIAN_CITY_MART, 1
    AddItem ITEM_PARCEL, 1, VAR_RESULT
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA4_sseq
    Message ViridianCity_Mart_Text_ReceivedOaksParcelFromClerk
    WaitFanfare
    WaitButton
    CloseMessage
    ReleaseAll
    End

ViridianCity_Mart_Clerk:
    GoToIfEq VAR_MAP_SCENE_VIRIDIAN_CITY_MART, 1, ViridianCity_Mart_SayHiToOak
    PokeMartCommonWithGreeting
    End

ViridianCity_Mart_SayHiToOak:
    NPCMessage ViridianCity_Mart_Text_SayHiToOakForMe
    End

ViridianCity_Mart_Woman:
    NPCMessage ViridianCity_Mart_Text_ShopDoesGoodBusinessInAntidotes
    End

ViridianCity_Mart_Youngster:
    NPCMessage ViridianCity_Mart_Text_GotToBuySomePotions
    End

    .balign 4, 0
ViridianCity_Mart_Movement_FaceSouth:
    WalkOnSpotFastSouth
    EndMovement

    .balign 4, 0
ViridianCity_Mart_Movement_ClerkFacePlayer:
    Delay16 4
    WalkOnSpotFastEast
    EndMovement

    .balign 4, 0
ViridianCity_Mart_Movement_ApproachCounter:
    WalkNormalNorth 5
    WalkOnSpotFastWest
    EndMovement
