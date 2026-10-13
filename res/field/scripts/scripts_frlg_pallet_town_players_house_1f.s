#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pallet_town_players_house_1f.h"
#include "res/field/events/kanto_events_455_t01r0101.h"

// FRLG's PalletTown_PlayersHouse_1F on HGSS's Red's house.


    ScriptEntry PalletTown_PlayersHouse_1F_Mom
    ScriptEntry PalletTown_PlayersHouse_1F_TV
    ScriptEntryEnd

PalletTown_PlayersHouse_1F_Mom:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_BEAT_RIVAL_IN_OAKS_LAB, PalletTown_PlayersHouse_1F_MomHeal
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, PalletTown_PlayersHouse_1F_MomOakLookingForYouFemale
    Message PalletTown_PlayersHouse_1F_Text_AllBoysLeaveOakLookingForYou
    GoTo PalletTown_PlayersHouse_1F_MomEnd
    End

PalletTown_PlayersHouse_1F_MomOakLookingForYouFemale:
    Message PalletTown_PlayersHouse_1F_Text_AllGirlsLeaveOakLookingForYou
PalletTown_PlayersHouse_1F_MomEnd:
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_MOM, PalletTown_PlayersHouse_1F_Movement_MomFaceTV
    WaitMovement
    ReleaseAll
    End

PalletTown_PlayersHouse_1F_MomHeal:
    BufferPlayerName 0
    Message PalletTown_PlayersHouse_1F_Text_YouShouldTakeQuickRest
    CloseMessage
    FadeScreenOut
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    FadeScreenIn
    WaitFadeScreen
    Message PalletTown_PlayersHouse_1F_Text_LookingGreatTakeCare
    WaitButton
    CloseMessage
    ReleaseAll
    End

PalletTown_PlayersHouse_1F_TV:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, PalletTown_PlayersHouse_1F_TVFemale
    Message PalletTown_PlayersHouse_1F_Text_MovieOnTVFourBoysOnRailroad
    GoTo PalletTown_PlayersHouse_1F_TVEnd
    End

PalletTown_PlayersHouse_1F_TVFemale:
    Message PalletTown_PlayersHouse_1F_Text_MovieOnTVGirlOnBrickRoad
PalletTown_PlayersHouse_1F_TVEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
PalletTown_PlayersHouse_1F_Movement_MomFaceTV:
    FaceNorth
    EndMovement
