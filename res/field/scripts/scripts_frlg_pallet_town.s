#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pallet_town.h"
#include "res/field/events/kanto_events_046_t01.h"

// FRLG's Pallet Town (pokefirered data/maps/PalletTown) on HGSS's map.


    ScriptEntry PalletTown_SignLady
    ScriptEntry PalletTown_FatMan
    ScriptEntry PalletTown_ProfOak
    ScriptEntry PalletTown_TownSign
    ScriptEntry PalletTown_PlayersHouseSign
    ScriptEntry PalletTown_RivalsHouseSign
    ScriptEntry PalletTown_OakPokemonResearchLabSign
    ScriptEntry PalletTown_OakTrigger
    ScriptEntryEnd

PalletTown_SignLady:
    NPCMessage PalletTown_Text_RaisingMonsToo
    End

PalletTown_FatMan:
    NPCMessage PalletTown_Text_CanStoreItemsAndMonsInPC
    End

PalletTown_ProfOak:
    End

PalletTown_TownSign:
    DrawSignpostInstantMessage PalletTown_Text_TownSign, SIGNPOST_TYPE_MAP, 1
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

PalletTown_PlayersHouseSign:
    BufferPlayerName 0
    ShowLandmarkSign PalletTown_Text_PlayersHouse
    End

PalletTown_RivalsHouseSign:
    BufferRivalName 1
    ShowLandmarkSign PalletTown_Text_RivalsHouse
    End

PalletTown_OakPokemonResearchLabSign:
    ShowLandmarkSign PalletTown_Text_OakPokemonResearchLab
    End

// The player tries to leave town without a Pokémon. Oak comes up from below
// the houses, then leads the player down to his lab's door (373, 373).
PalletTown_OakTrigger:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    PlayMusic SEQ_GS_OHKIDO_sseq
    Message PalletTown_Text_OakDontGoOut
    CloseMessage
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerNoticeOak
    WaitMovement
    SetObjectEventPos LOCALID_PROF_OAK, VAR_0x8004, 363
    ClearFlag FLAG_HIDE_OAK_IN_PALLET_TOWN
    AddObject LOCALID_PROF_OAK
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakWalkToPlayer
    WaitMovement
    Message PalletTown_Text_OakGrassUnsafeNeedMon
    CloseMessage
    GoToIfEq VAR_0x8004, 366, PalletTown_OakLeadX366
    GoToIfEq VAR_0x8004, 367, PalletTown_OakLeadX367
    GoToIfEq VAR_0x8004, 368, PalletTown_OakLeadX368
    GoTo PalletTown_OakLeadX369
    End

PalletTown_OakLeadX366:
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakLeadX366
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerFollowX366
    WaitMovement
    GoTo PalletTown_EnterLab
    End

PalletTown_OakLeadX367:
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakLeadX367
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerFollowX367
    WaitMovement
    GoTo PalletTown_EnterLab
    End

PalletTown_OakLeadX368:
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakLeadX368
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerFollowX368
    WaitMovement
    GoTo PalletTown_EnterLab
    End

PalletTown_OakLeadX369:
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakLeadX369
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerFollowX369
    WaitMovement
    GoTo PalletTown_EnterLab
    End

PalletTown_EnterLab:
    LoadDoorAnimation 11, 11, 21, 21, ANIMATION_TAG_DOOR_1
    PlayDoorOpenAnimation ANIMATION_TAG_DOOR_1
    WaitForAnimation ANIMATION_TAG_DOOR_1
    ApplyMovement LOCALID_PROF_OAK, PalletTown_Movement_OakEnterLab
    ApplyMovement LOCALID_PLAYER, PalletTown_Movement_PlayerEnterLab
    WaitMovement
    PlayDoorCloseAnimation ANIMATION_TAG_DOOR_1
    WaitForAnimation ANIMATION_TAG_DOOR_1
    UnloadAnimation ANIMATION_TAG_DOOR_1
    RemoveObject LOCALID_PROF_OAK
    SetFlag FLAG_HIDE_OAK_IN_PALLET_TOWN
    ClearFlag FLAG_HIDE_OAK_IN_HIS_LAB
    SetVar VAR_MAP_SCENE_PALLET_TOWN_OAK, 1
    SetVar VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 1
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_KANTO_PALLET_TOWN_OAKS_LAB, 8, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

    .balign 4, 0
PalletTown_Movement_PlayerNoticeOak:
    WalkOnSpotFastSouth
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
PalletTown_Movement_OakWalkToPlayer:
    WalkNormalNorth 7
    EndMovement

// Oak walks down to the row below the lab and along it to the door; the
// player keeps one step behind.
    .balign 4, 0
PalletTown_Movement_OakLeadX366:
    WalkNormalSouth 18
    WalkNormalEast 7
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
PalletTown_Movement_PlayerFollowX366:
    WalkNormalSouth 19
    WalkNormalEast 6
    EndMovement

    .balign 4, 0
PalletTown_Movement_OakLeadX367:
    WalkNormalSouth 18
    WalkNormalEast 6
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
PalletTown_Movement_PlayerFollowX367:
    WalkNormalSouth 19
    WalkNormalEast 5
    EndMovement

    .balign 4, 0
PalletTown_Movement_OakLeadX368:
    WalkNormalSouth 18
    WalkNormalEast 5
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
PalletTown_Movement_PlayerFollowX368:
    WalkNormalSouth 19
    WalkNormalEast 4
    EndMovement

    .balign 4, 0
PalletTown_Movement_OakLeadX369:
    WalkNormalSouth 18
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
PalletTown_Movement_PlayerFollowX369:
    WalkNormalSouth 19
    WalkNormalEast 3
    EndMovement

    .balign 4, 0
PalletTown_Movement_OakEnterLab:
    WalkNormalNorth
    SetInvisible
    EndMovement

    .balign 4, 0
PalletTown_Movement_PlayerEnterLab:
    Delay8 2
    WalkNormalEast
    WalkNormalNorth
    SetInvisible
    EndMovement
