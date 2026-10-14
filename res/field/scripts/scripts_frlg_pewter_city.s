#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city.h"
#include "res/field/events/kanto_events_048_t03.h"

// FRLG's Pewter City on HGSS's.
//
// The way east to Route 3 is x 404, rows 102 to 105. Before the Boulder
// Badge, the Gym guide stops the player there and takes them to the Gym;
// after it, Oak's aide comes up with the Running Shoes. Where FRLG's guides
// walk the player across town, here the screen fades and the player is at
// the door (the Gym's at 375, 92, the Museum's at 376, 78).
//
// VAR_MAP_SCENE_PEWTER_CITY is FRLG's: 0 before the Boulder Badge, 1 after,
// 2 with the Running Shoes. Entering the town resets the Museum's ticket
// (VAR_MAP_SCENE_PEWTER_CITY_MUSEUM_1F), as in FRLG.


    ScriptEntry PewterCity_OnTransition
    ScriptEntry PewterCity_Lass
    ScriptEntry PewterCity_MuseumGuide
    ScriptEntry PewterCity_FatMan
    ScriptEntry PewterCity_BugCatcher
    ScriptEntry PewterCity_GymGuide
    ScriptEntry PewterCity_RunningShoesAide
    ScriptEntry PewterCity_CitySign
    ScriptEntry PewterCity_GymSign
    ScriptEntry PewterCity_MuseumSign
    ScriptEntry PewterCity_TrainerTips
    ScriptEntry PewterCity_GymGuideTrigger
    ScriptEntry PewterCity_RunningShoesAideTrigger
    ScriptEntryEnd

PewterCity_OnTransition:
    SetVar VAR_MAP_SCENE_PEWTER_CITY_MUSEUM_1F, 0
    End

PewterCity_Lass:
    NPCMessage PewterCity_Text_ClefairyCameFromMoon
    End

PewterCity_FatMan:
    NPCMessage PewterCity_Text_BrockOnlySeriousTrainerHere
    End

PewterCity_BugCatcher:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message PewterCity_Text_DoYouKnowWhatImDoing
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_YES, PewterCity_KnowWhatTheyreDoing
    Message PewterCity_Text_SprayingRepelToKeepWildMonsOut
    GoTo PewterCity_MessageEnd
    End

PewterCity_KnowWhatTheyreDoing:
    Message PewterCity_Text_ThatsRightItsHardWork
    GoTo PewterCity_MessageEnd
    End

PewterCity_MessageEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End

PewterCity_MuseumGuide:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message PewterCity_Text_DidYouCheckOutMuseum
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, PewterCity_LeadToMuseum
    Message PewterCity_Text_WerentThoseFossilsAmazing
    GoTo PewterCity_MessageEnd
    End

PewterCity_LeadToMuseum:
    Message PewterCity_Text_ReallyYouHaveToGo
    WaitButton
    CloseMessage
    PlayMusic SEQ_GS_E_TSURETEKE1_sseq
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_KANTO_PEWTER, 376, 79, DIR_NORTH
    SetPosition LOCALID_MUSEUM_GUIDE, 377, 0, 79, DIR_WEST
    FadeScreenIn
    WaitFadeScreen
    Message PewterCity_Text_ThisIsTheMuseum
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    ReleaseAll
    End

PewterCity_GymGuide:
PewterCity_GymGuideTrigger:
    LockAll
    Message PewterCity_Text_BrocksLookingForChallengersFollowMe
    WaitButton
    CloseMessage
    PlayMusic SEQ_GS_E_TSURETEKE1_sseq
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_KANTO_PEWTER, 375, 93, DIR_NORTH
    SetPosition LOCALID_GYM_GUIDE, 376, 0, 93, DIR_WEST
    FadeScreenIn
    WaitFadeScreen
    Message PewterCity_Text_GoTakeOnBrock
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_GYM_GUIDE, PewterCity_Movement_GymGuideExit
    WaitMovement
    RemoveObject LOCALID_GYM_GUIDE
    ClearFlag FLAG_HIDE_PEWTER_CITY_GYM_GUIDE
    Common_FadeToDefaultMusic
    ReleaseAll
    End

// The aide stands at (405, 101); he comes to the tile east of the player.
PewterCity_RunningShoesAideTrigger:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_Exclamation
    WaitMovement
    BufferPlayerName 0
    Message PewterCity_Text_OhPlayer
    WaitButton
    CloseMessage
    CallIfEq VAR_0x8005, 102, PewterCity_AideApproach102
    CallIfEq VAR_0x8005, 103, PewterCity_AideApproach103
    CallIfEq VAR_0x8005, 104, PewterCity_AideApproach104
    CallIfEq VAR_0x8005, 105, PewterCity_AideApproach105
    ApplyMovement LOCALID_PLAYER, PewterCity_Movement_FaceEast
    WaitMovement
    GoTo PewterCity_GiveRunningShoes
    End

PewterCity_RunningShoesAide:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message PewterCity_Text_OhPlayer
    WaitButton
PewterCity_GiveRunningShoes:
    Message PewterCity_Text_AskedToDeliverThis
    WaitButton
    GiveRunningShoes
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA4_sseq
    Message PewterCity_Text_ReceivedRunningShoesFromAide
    WaitFanfare
    WaitButton
    Message PewterCity_Text_SwitchedShoesWithRunningShoes
    WaitButton
    Message PewterCity_Text_ExplainRunningShoes
    WaitButton
    Message PewterCity_Text_MustBeGoingBackToLab
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_AideExit
    WaitMovement
    RemoveObject LOCALID_AIDE
    WaitTime 30, VAR_RESULT
    Message PewterCity_Text_RunningShoesLetterFromMom
    WaitButton
    CloseMessage
    SetVar VAR_MAP_SCENE_PEWTER_CITY, 2
    ReleaseAll
    End

PewterCity_AideApproach102:
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_AideApproach102
    WaitMovement
    Return

PewterCity_AideApproach103:
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_AideApproach103
    WaitMovement
    Return

PewterCity_AideApproach104:
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_AideApproach104
    WaitMovement
    Return

PewterCity_AideApproach105:
    ApplyMovement LOCALID_AIDE, PewterCity_Movement_AideApproach105
    WaitMovement
    Return

PewterCity_CitySign:
    DrawSignpostInstantMessage PewterCity_Text_CitySign, SIGNPOST_TYPE_MAP, 3
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

PewterCity_GymSign:
    EventMessage PewterCity_Text_GymSign
    End

PewterCity_MuseumSign:
    ShowLandmarkSign PewterCity_Text_MuseumOfScience
    End

PewterCity_TrainerTips:
    EventMessage PewterCity_Text_TrainerTipsEarningEXP
    End

    .balign 4, 0
PewterCity_Movement_GymGuideExit:
    WalkNormalEast 2
    SetInvisible
    EndMovement

    .balign 4, 0
PewterCity_Movement_Exclamation:
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
PewterCity_Movement_FaceEast:
    WalkOnSpotFastEast
    EndMovement

    .balign 4, 0
PewterCity_Movement_AideApproach102:
    WalkNormalSouth
    WalkNormalWest
    EndMovement

    .balign 4, 0
PewterCity_Movement_AideApproach103:
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement

    .balign 4, 0
PewterCity_Movement_AideApproach104:
    WalkNormalSouth 3
    WalkNormalWest
    EndMovement

    .balign 4, 0
PewterCity_Movement_AideApproach105:
    WalkNormalSouth 4
    WalkNormalWest
    EndMovement

    .balign 4, 0
PewterCity_Movement_AideExit:
    WalkNormalEast 3
    SetInvisible
    EndMovement
