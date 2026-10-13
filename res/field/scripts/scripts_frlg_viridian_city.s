#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_city.h"
#include "res/field/events/kanto_events_047_t02.h"

// FRLG's Viridian City on HGSS's.
//
// FRLG's grumpy old man lies across the one road north until Oak has the
// Pokédex. HGSS's Viridian has several ways north, all crossing row 236, so
// triggers along that row send the player back. Once the player has the
// Pokédex, the same row starts his catching demonstration.
//
// VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN is FRLG's:
//     0  he blocks the road
//     1  he waits to show how to catch Pokémon
//     2  he has shown it
// The Gym stays locked (VAR_MAP_SCENE_VIRIDIAN_CITY_GYM_DOOR 0) until its
// Leader returns, which isn't ported yet.


    ScriptEntry ViridianCity_OnTransition
    ScriptEntry ViridianCity_TutorialOldMan
    ScriptEntry ViridianCity_Woman
    ScriptEntry ViridianCity_OldMan
    ScriptEntry ViridianCity_Youngster
    ScriptEntry ViridianCity_Boy
    ScriptEntry ViridianCity_CitySign
    ScriptEntry ViridianCity_TrainerTips1
    ScriptEntry ViridianCity_GymSign
    ScriptEntry ViridianCity_TrainerTips2
    ScriptEntry ViridianCity_RoadBlocked
    ScriptEntry ViridianCity_TutorialTrigger
    ScriptEntry ViridianCity_GymDoorLocked
    ScriptEntryEnd

ViridianCity_OnTransition:
    CallIfGe VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN, 1, ViridianCity_SetOldManStandingByRoad
    End

ViridianCity_SetOldManStandingByRoad:
    SetObjectEventPos LOCALID_TUTORIAL_MAN, 355, 238
    SetObjectEventMovementType LOCALID_TUTORIAL_MAN, MOVEMENT_TYPE_LOOK_AROUND
    Return

ViridianCity_RoadBlocked:
    LockAll
    Message ViridianCity_Text_ThisIsPrivateProperty
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_PLAYER, ViridianCity_Movement_WalkSouth
    WaitMovement
    ReleaseAll
    End

ViridianCity_TutorialTrigger:
    LockAll
    ApplyMovement LOCALID_TUTORIAL_MAN, ViridianCity_Movement_FaceNorth
    ApplyMovement LOCALID_PLAYER, ViridianCity_Movement_FaceSouth
    WaitMovement
    Call ViridianCity_DoTutorialBattle
    ReleaseAll
    End

ViridianCity_TutorialOldMan:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfGe VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN, 2, ViridianCity_TutorialCompleted
    GoToIfEq VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN, 1, ViridianCity_TutorialStart
    Message ViridianCity_Text_ThisIsPrivateProperty
    GoTo ViridianCity_MessageEnd
    End

ViridianCity_TutorialStart:
    Call ViridianCity_DoTutorialBattle
    ReleaseAll
    End

ViridianCity_TutorialCompleted:
    Message ViridianCity_Text_WeakenMonsFirstToCatch
    GoTo ViridianCity_MessageEnd
    End

// FRLG then says "that was educational" and gives the Teachy TV, which
// Platinum lacks, so the demonstration ends with the battle.
ViridianCity_DoTutorialBattle:
    Message ViridianCity_Text_ShowYouHowToCatchMons
    WaitButton
    CloseMessage
    StartCatchingTutorial
    SetVar VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN, 2
    Return

ViridianCity_Woman:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfEq VAR_MAP_SCENE_VIRIDIAN_CITY_OLD_MAN, 0, ViridianCity_WomanRoadBlocked
    Message ViridianCity_Text_GoShoppingInPewterOccasionally
    GoTo ViridianCity_MessageEnd
    End

ViridianCity_WomanRoadBlocked:
    Message ViridianCity_Text_GrandpaHasntHadCoffeeYet
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_WOMAN, ViridianCity_Movement_FaceNorth
    WaitMovement
    ReleaseAll
    End

ViridianCity_OldMan:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfEq VAR_MAP_SCENE_VIRIDIAN_CITY_GYM_DOOR, 1, ViridianCity_OldManGymLeaderReturned
    Message ViridianCity_Text_GymClosedWonderWhoLeaderIs
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_OLD_MAN, ViridianCity_Movement_FaceNorth
    WaitMovement
    ReleaseAll
    End

ViridianCity_OldManGymLeaderReturned:
    Message ViridianCity_Text_ViridiansGymLeaderReturned
    GoTo ViridianCity_MessageEnd
    End

ViridianCity_Youngster:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message ViridianCity_Text_WantToKnowAboutCaterpillarMons
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, ViridianCity_YoungsterDeclineExplanation
    Message ViridianCity_Text_ExplainCaterpieWeedle
    GoTo ViridianCity_MessageEnd
    End

ViridianCity_YoungsterDeclineExplanation:
    Message ViridianCity_Text_OhOkayThen
    GoTo ViridianCity_MessageEnd
    End

ViridianCity_Boy:
    NPCMessage ViridianCity_Text_CanCarryMonsAnywhere
    End

ViridianCity_MessageEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End

ViridianCity_CitySign:
    DrawSignpostInstantMessage ViridianCity_Text_CitySign, SIGNPOST_TYPE_MAP, 2
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

ViridianCity_TrainerTips1:
    EventMessage ViridianCity_Text_CatchMonsForEasierBattles
    End

ViridianCity_GymSign:
    ShowLandmarkSign ViridianCity_Text_GymSign
    End

ViridianCity_TrainerTips2:
    EventMessage ViridianCity_Text_MovesLimitedByPP
    End

ViridianCity_GymDoorLocked:
    LockAll
    ApplyMovement LOCALID_PLAYER, ViridianCity_Movement_FaceNorth
    WaitMovement
    WaitTime 20, VAR_RESULT
    Message ViridianCity_Text_GymDoorsAreLocked
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_PLAYER, ViridianCity_Movement_WalkSouth
    WaitMovement
    ReleaseAll
    End

    .balign 4, 0
ViridianCity_Movement_WalkSouth:
    WalkNormalSouth
    EndMovement

    .balign 4, 0
ViridianCity_Movement_FaceNorth:
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
ViridianCity_Movement_FaceSouth:
    WalkOnSpotFastSouth
    EndMovement
