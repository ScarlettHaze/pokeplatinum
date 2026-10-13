#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pallet_town_rivals_house.h"
#include "res/field/events/kanto_events_456_t01r0201.h"

// FRLG's PalletTown_RivalsHouse on HGSS's Blue's house. HGSS's house has no
// Town Map on the wall, so Daisy gives one without taking it down.
//
// VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE: 0 before the Pokédex, 1 she has
// the Town Map for the player, 2 she just gave it, 3 later visits. (FRLG
// keeps explaining it until the player leaves the house.)


    ScriptEntry PalletTown_RivalsHouse_Daisy
    ScriptEntryEnd

PalletTown_RivalsHouse_Daisy:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferRivalName 1
    GoToIfGe VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE, 3, PalletTown_RivalsHouse_PleaseGiveMonsRest
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE, 2, PalletTown_RivalsHouse_ExplainTownMap
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE, 1, PalletTown_RivalsHouse_GiveTownMap
    GoToIfGe VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 1, PalletTown_RivalsHouse_HeardBattledRival
    Message PalletTown_RivalsHouse_Text_HiBrothersAtLab
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_DAISY, PalletTown_RivalsHouse_Movement_DaisyFaceEast
    WaitMovement
    ReleaseAll
    End

PalletTown_RivalsHouse_HeardBattledRival:
    Message PalletTown_RivalsHouse_Text_HeardYouBattledRival
    WaitButton
    CloseMessage
    ReleaseAll
    End

PalletTown_RivalsHouse_PleaseGiveMonsRest:
    Message PalletTown_RivalsHouse_Text_PleaseGiveMonsRest
    WaitButton
    CloseMessage
    ReleaseAll
    End

PalletTown_RivalsHouse_ExplainTownMap:
    Message PalletTown_RivalsHouse_Text_ExplainTownMap
    WaitButton
    CloseMessage
    SetVar VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE, 3
    ReleaseAll
    End

PalletTown_RivalsHouse_GiveTownMap:
    Message PalletTown_RivalsHouse_Text_ErrandForGrandpaThisWillHelp
    WaitButton
    GoToIfCannotFitItem ITEM_TOWN_MAP, 1, VAR_RESULT, PalletTown_RivalsHouse_NoRoomForTownMap
    AddItem ITEM_TOWN_MAP, 1, VAR_RESULT
    SetVar VAR_MAP_SCENE_PALLET_TOWN_RIVALS_HOUSE, 2
    PlayFanfare SEQ_FANFA4_sseq
    Message PalletTown_RivalsHouse_Text_ReceivedTownMapFromDaisy
    WaitFanfare
    WaitButton
    CloseMessage
    ReleaseAll
    End

PalletTown_RivalsHouse_NoRoomForTownMap:
    Message PalletTown_RivalsHouse_Text_DontHaveSpaceForThis
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
PalletTown_RivalsHouse_Movement_DaisyFaceEast:
    FaceEast
    EndMovement
