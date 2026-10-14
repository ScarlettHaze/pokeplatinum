#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_gym.h"
#include "res/field/events/kanto_events_426_t03gym0101.h"

// FRLG's Pewter Gym on HGSS's. The Boulder Badge is Platinum's first badge
// (BADGE_ID_COAL). Brock's defeat speech is too long for a battle message:
// its first page shows in battle, the rest here.


    ScriptEntry PewterCity_Gym_Brock
    ScriptEntry PewterCity_Gym_GymGuy
    ScriptEntry PewterCity_Gym_GymStatue
    ScriptEntryEnd

PewterCity_Gym_Brock:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COAL, PewterCity_Gym_BrockAfterBadge
    Message PewterCity_Gym_Text_BrockIntro
    WaitButton
    CloseMessage
    StartTrainerBattle TRAINER_FRLG_LEADER_BROCK
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, PewterCity_Gym_LostBattle
    Message PewterCity_Gym_Text_BrockConferBadge
    WaitButton
    BufferPlayerName 0
    Message PewterCity_Gym_Text_ReceivedBoulderBadge
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    GiveBadge BADGE_ID_COAL
    SetTrainerFlag TRAINER_FRLG_CAMPER_LIAM
    SetVar VAR_MAP_SCENE_PEWTER_CITY, 1
    SetFlag FLAG_HIDE_PEWTER_CITY_GYM_GUIDE
    ClearFlag FLAG_HIDE_PEWTER_CITY_RUNNING_SHOES_GUY
    Message PewterCity_Gym_Text_BoulderBadgeExplanation
    WaitButton
    GoTo PewterCity_Gym_GiveTM39
    End

PewterCity_Gym_BrockAfterBadge:
    GoToIfUnset FLAG_GOT_TM39_FROM_BROCK, PewterCity_Gym_GiveTM39
    Message PewterCity_Gym_Text_BrockPostBattle
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_GiveTM39:
    Message PewterCity_Gym_Text_TakeThisWithYou
    WaitButton
    GoToIfCannotFitItem ITEM_TM39, 1, VAR_RESULT, PewterCity_Gym_NoRoomForTM39
    AddItem ITEM_TM39, 1, VAR_RESULT
    SetFlag FLAG_GOT_TM39_FROM_BROCK
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA1_sseq
    Message PewterCity_Gym_Text_ReceivedTM39FromBrock
    WaitFanfare
    WaitButton
    Message PewterCity_Gym_Text_ExplainTM39
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_NoRoomForTM39:
    Message PewterCity_Gym_Text_DontHaveRoomForThis
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

PewterCity_Gym_GymGuy:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COAL, PewterCity_Gym_GymGuyPostVictory
    BufferPlayerName 0
    Message PewterCity_Gym_Text_LetMeTakeYouToTheTop
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, PewterCity_Gym_GymGuyDontTakeMeToTop
    Message PewterCity_Gym_Text_LetsGetHappening
    GoTo PewterCity_Gym_GymGuyAdvice
    End

PewterCity_Gym_GymGuyDontTakeMeToTop:
    Message PewterCity_Gym_Text_ItsFreeLetsGetHappening
PewterCity_Gym_GymGuyAdvice:
    WaitButton
    Message PewterCity_Gym_Text_TryDifferentPartyOrders
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_GymGuyPostVictory:
    Message PewterCity_Gym_Text_YoureChampMaterial
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_GymStatue:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    GoToIfBadgeAcquired BADGE_ID_COAL, PewterCity_Gym_GymStatuePostVictory
    Message PewterCity_Gym_Text_GymStatue
    GoTo PewterCity_Gym_MessageEnd
    End

PewterCity_Gym_GymStatuePostVictory:
    Message PewterCity_Gym_Text_GymStatuePlayerWon
PewterCity_Gym_MessageEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End
