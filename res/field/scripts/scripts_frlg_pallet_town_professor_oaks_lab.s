#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pallet_town_professor_oaks_lab.h"
#include "res/field/events/kanto_events_457_t01r0301.h"

// FRLG's PalletTown_ProfessorOaksLab on HGSS's lab: the starter choice and
// the first battle with the rival.
//
// HGSS's lab has the three Poké Balls on the desk at the back (7..9, 3), so
// the player picks a ball standing below it. Oak stands at his HGSS spot
// (8, 6) in front of the desk and the rival waits beside the player at (7, 7).
// Rows 9 to 11 between the bookshelves are the only way to the door (8, 13),
// which is where the triggers that keep the player in are.
//
// VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB is FRLG's:
//     0  Oak is out, the rival waits
//     1  Oak has brought the player in
//     2  choosing a starter
//     3  chose one; the rival wants to battle on the way out
//     4  battled the rival
// VAR_PLAYER_STARTER holds the player's starter species from the choice on.


    ScriptEntry PalletTown_ProfessorOaksLab_OnTransition
    ScriptEntry PalletTown_ProfessorOaksLab_ChooseStarterScene
    ScriptEntry PalletTown_ProfessorOaksLab_ProfOak
    ScriptEntry PalletTown_ProfessorOaksLab_Rival
    ScriptEntry PalletTown_ProfessorOaksLab_BulbasaurBall
    ScriptEntry PalletTown_ProfessorOaksLab_SquirtleBall
    ScriptEntry PalletTown_ProfessorOaksLab_CharmanderBall
    ScriptEntry PalletTown_ProfessorOaksLab_Aide1
    ScriptEntry PalletTown_ProfessorOaksLab_Aide2
    ScriptEntry PalletTown_ProfessorOaksLab_Aide3
    ScriptEntry PalletTown_ProfessorOaksLab_Computer
    ScriptEntry PalletTown_ProfessorOaksLab_Bookshelf
    ScriptEntry PalletTown_ProfessorOaksLab_LeaveStarterSceneTrigger
    ScriptEntry PalletTown_ProfessorOaksLab_RivalBattleTrigger
    ScriptEntry PalletTown_ProfessorOaksLab_PokeBallObject
    ScriptEntryEnd

PalletTown_ProfessorOaksLab_OnTransition:
    CallIfEq VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 1, PalletTown_ProfessorOaksLab_ReadyOakForStarterScene
    End

// Oak came in just ahead of the player.
PalletTown_ProfessorOaksLab_ReadyOakForStarterScene:
    SetObjectEventPos LOCALID_PROF_OAK, 8, 12
    SetObjectEventDir LOCALID_PROF_OAK, DIR_NORTH
    SetObjectEventMovementType LOCALID_PROF_OAK, MOVEMENT_TYPE_LOOK_NORTH
    Return

PalletTown_ProfessorOaksLab_ChooseStarterScene:
    LockAll
    ApplyMovement LOCALID_PROF_OAK, PalletTown_ProfessorOaksLab_Movement_OakEnter
    WaitMovement
    ApplyMovement LOCALID_PLAYER, PalletTown_ProfessorOaksLab_Movement_PlayerEnter
    WaitMovement
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_FaceNorth
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message PalletTown_ProfessorOaksLab_Text_RivalFedUpWithWaiting
    WaitButton
    CloseMessage
    WaitTime 60, VAR_RESULT
    Message PalletTown_ProfessorOaksLab_Text_OakThreeMonsChooseOne
    WaitButton
    CloseMessage
    WaitTime 30, VAR_RESULT
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalReact
    WaitMovement
    Message PalletTown_ProfessorOaksLab_Text_RivalNoFairWhatAboutMe
    WaitButton
    Message PalletTown_ProfessorOaksLab_Text_OakBePatientRival
    WaitButton
    CloseMessage
    SetVar VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 2
    ReleaseAll
    End

PalletTown_ProfessorOaksLab_LeaveStarterSceneTrigger:
    LockAll
    ApplyMovement LOCALID_PROF_OAK, PalletTown_ProfessorOaksLab_Movement_FaceSouth
    WaitMovement
    Message PalletTown_ProfessorOaksLab_Text_OakHeyDontGoAwayYet
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_PLAYER, PalletTown_ProfessorOaksLab_Movement_WalkNorth
    WaitMovement
    ReleaseAll
    End

PalletTown_ProfessorOaksLab_ProfOak:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfGe VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 4, PalletTown_ProfessorOaksLab_OakBattleMonForItToGrow
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 3, PalletTown_ProfessorOaksLab_OakCanReachNextTownWithMon
    Message PalletTown_ProfessorOaksLab_Text_OakWhichOneWillYouChoose
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_OakBattleMonForItToGrow:
    Message PalletTown_ProfessorOaksLab_Text_OakBattleMonForItToGrow
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_OakCanReachNextTownWithMon:
    Message PalletTown_ProfessorOaksLab_Text_OakCanReachNextTownWithMon
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_Rival:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferRivalName 1
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 3, PalletTown_ProfessorOaksLab_RivalChoseStarter
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 2, PalletTown_ProfessorOaksLab_RivalWaitingForStarter
    Message PalletTown_ProfessorOaksLab_Text_RivalGrampsIsntAround
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_RivalWaitingForStarter:
    Message PalletTown_ProfessorOaksLab_Text_RivalGoChoosePlayer
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_RivalChoseStarter:
    Message PalletTown_ProfessorOaksLab_Text_RivalMyMonLooksTougher
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_MessageEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End

PalletTown_ProfessorOaksLab_BulbasaurBall:
    GoToIfSet FLAG_HIDE_BULBASAUR_BALL, PalletTown_ProfessorOaksLab_PokeBallObject
    SetVar VAR_0x8008, SPECIES_BULBASAUR
    GoTo PalletTown_ProfessorOaksLab_PokeBall
    End

PalletTown_ProfessorOaksLab_SquirtleBall:
    GoToIfSet FLAG_HIDE_SQUIRTLE_BALL, PalletTown_ProfessorOaksLab_PokeBallObject
    SetVar VAR_0x8008, SPECIES_SQUIRTLE
    GoTo PalletTown_ProfessorOaksLab_PokeBall
    End

PalletTown_ProfessorOaksLab_CharmanderBall:
    GoToIfSet FLAG_HIDE_CHARMANDER_BALL, PalletTown_ProfessorOaksLab_PokeBallObject
    SetVar VAR_0x8008, SPECIES_CHARMANDER
    GoTo PalletTown_ProfessorOaksLab_PokeBall
    End

PalletTown_ProfessorOaksLab_PokeBallObject:
    End

// VAR_0x8008: the species in the ball.
PalletTown_ProfessorOaksLab_PokeBall:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfGe VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 3, PalletTown_ProfessorOaksLab_LastPokeBall
    GoToIfEq VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 2, PalletTown_ProfessorOaksLab_ConfirmStarterChoice
    Message PalletTown_ProfessorOaksLab_Text_ThoseArePokeBalls
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_LastPokeBall:
    Message PalletTown_ProfessorOaksLab_Text_OaksLastMon
    GoTo PalletTown_ProfessorOaksLab_MessageEnd
    End

PalletTown_ProfessorOaksLab_ConfirmStarterChoice:
    ApplyMovement LOCALID_PROF_OAK, PalletTown_ProfessorOaksLab_Movement_FaceNorth
    WaitMovement
    DrawPokemonPreview VAR_0x8008, GENDER_MALE
    BufferPlayerName 0
    CallIfEq VAR_0x8008, SPECIES_BULBASAUR, PalletTown_ProfessorOaksLab_OakChoosingBulbasaur
    CallIfEq VAR_0x8008, SPECIES_SQUIRTLE, PalletTown_ProfessorOaksLab_OakChoosingSquirtle
    CallIfEq VAR_0x8008, SPECIES_CHARMANDER, PalletTown_ProfessorOaksLab_OakChoosingCharmander
    ShowYesNoMenu VAR_RESULT
    RemovePokemonPreview
    GoToIfEq VAR_RESULT, MENU_YES, PalletTown_ProfessorOaksLab_ChoseStarter
    CloseMessage
    ReleaseAll
    End

PalletTown_ProfessorOaksLab_OakChoosingBulbasaur:
    Message PalletTown_ProfessorOaksLab_Text_OakChoosingBulbasaur
    Return

PalletTown_ProfessorOaksLab_OakChoosingSquirtle:
    Message PalletTown_ProfessorOaksLab_Text_OakChoosingSquirtle
    Return

PalletTown_ProfessorOaksLab_OakChoosingCharmander:
    Message PalletTown_ProfessorOaksLab_Text_OakChoosingCharmander
    Return

PalletTown_ProfessorOaksLab_ChoseStarter:
    CallIfEq VAR_0x8008, SPECIES_BULBASAUR, PalletTown_ProfessorOaksLab_RemoveBulbasaurBall
    CallIfEq VAR_0x8008, SPECIES_SQUIRTLE, PalletTown_ProfessorOaksLab_RemoveSquirtleBall
    CallIfEq VAR_0x8008, SPECIES_CHARMANDER, PalletTown_ProfessorOaksLab_RemoveCharmanderBall
    Message PalletTown_ProfessorOaksLab_Text_OakThisMonIsEnergetic
    WaitButton
    SetVar VAR_PLAYER_STARTER, VAR_0x8008
    GivePokemon VAR_0x8008, 5, ITEM_NONE, VAR_RESULT
    BufferSpeciesNameFromVar 2, VAR_0x8008, 0, 0
    PlayFanfare SEQ_FANFA4_sseq
    Message PalletTown_ProfessorOaksLab_Text_ReceivedMonFromOak
    WaitFanfare
    WaitButton
    Message Text_GiveNicknameToThisMon
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, PalletTown_ProfessorOaksLab_DeclineNickname
    CloseMessage
    FadeScreenOut
    WaitFadeScreen
    OpenPokemonNamingScreen 0, VAR_RESULT
    FadeScreenIn
    WaitFadeScreen
    GoTo PalletTown_ProfessorOaksLab_RivalPicksStarter
    End

PalletTown_ProfessorOaksLab_RemoveBulbasaurBall:
    RemoveObject LOCALID_BULBASAUR_BALL
    Return

PalletTown_ProfessorOaksLab_RemoveSquirtleBall:
    RemoveObject LOCALID_SQUIRTLE_BALL
    Return

PalletTown_ProfessorOaksLab_RemoveCharmanderBall:
    RemoveObject LOCALID_CHARMANDER_BALL
    Return

PalletTown_ProfessorOaksLab_DeclineNickname:
    CloseMessage
    GoTo PalletTown_ProfessorOaksLab_RivalPicksStarter
    End

// The rival takes the ball to the right of the player's, like in FRLG: he
// walks up to it from his place at (7, 7), round Oak.
PalletTown_ProfessorOaksLab_RivalPicksStarter:
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_BULBASAUR, PalletTown_ProfessorOaksLab_RivalTakesCharmander
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_SQUIRTLE, PalletTown_ProfessorOaksLab_RivalTakesBulbasaur
    GoTo PalletTown_ProfessorOaksLab_RivalTakesSquirtle
    End

PalletTown_ProfessorOaksLab_RivalTakesCharmander:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalWalkToCharmander
    WaitMovement
    Call PalletTown_ProfessorOaksLab_RivalIllTakeThisOne
    RemoveObject LOCALID_CHARMANDER_BALL
    SetVar VAR_0x8008, SPECIES_CHARMANDER
    GoTo PalletTown_ProfessorOaksLab_RivalReceivedStarter
    End

PalletTown_ProfessorOaksLab_RivalTakesBulbasaur:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalWalkToBulbasaur
    WaitMovement
    Call PalletTown_ProfessorOaksLab_RivalIllTakeThisOne
    RemoveObject LOCALID_BULBASAUR_BALL
    SetVar VAR_0x8008, SPECIES_BULBASAUR
    GoTo PalletTown_ProfessorOaksLab_RivalReceivedStarter
    End

PalletTown_ProfessorOaksLab_RivalTakesSquirtle:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalWalkToSquirtle
    WaitMovement
    Call PalletTown_ProfessorOaksLab_RivalIllTakeThisOne
    RemoveObject LOCALID_SQUIRTLE_BALL
    SetVar VAR_0x8008, SPECIES_SQUIRTLE
    GoTo PalletTown_ProfessorOaksLab_RivalReceivedStarter
    End

PalletTown_ProfessorOaksLab_RivalIllTakeThisOne:
    BufferRivalName 1
    Message PalletTown_ProfessorOaksLab_Text_RivalIllTakeThisOneThen
    WaitButton
    Return

PalletTown_ProfessorOaksLab_RivalReceivedStarter:
    BufferSpeciesNameFromVar 2, VAR_0x8008, 0, 0
    PlayFanfare SEQ_FANFA4_sseq
    Message PalletTown_ProfessorOaksLab_Text_RivalReceivedMonFromOak
    WaitFanfare
    WaitButton
    CloseMessage
    SetVar VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 3
    ReleaseAll
    End

// The player heads for the door. The rival, still at the ball he took, comes
// down beside Oak to the row above the player and along it, then battles.
PalletTown_ProfessorOaksLab_RivalBattleTrigger:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    PlayMusic SEQ_GS_E_RIVAL1_sseq
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_FaceSouth
    ApplyMovement LOCALID_PLAYER, PalletTown_ProfessorOaksLab_Movement_FaceNorth
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message PalletTown_ProfessorOaksLab_Text_RivalLetsCheckOutMons
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_PROF_OAK, PalletTown_ProfessorOaksLab_Movement_FaceSouth
    WaitMovement
    CallIfEq VAR_PLAYER_STARTER, SPECIES_BULBASAUR, PalletTown_ProfessorOaksLab_RivalApproachFromCharmander
    CallIfEq VAR_PLAYER_STARTER, SPECIES_SQUIRTLE, PalletTown_ProfessorOaksLab_RivalApproachFromBulbasaur
    CallIfEq VAR_PLAYER_STARTER, SPECIES_CHARMANDER, PalletTown_ProfessorOaksLab_RivalApproachFromSquirtle
    Call PalletTown_ProfessorOaksLab_RivalWalkAlongRow
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_FaceSouth
    WaitMovement
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_BULBASAUR, PalletTown_ProfessorOaksLab_RivalBattleCharmander
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_SQUIRTLE, PalletTown_ProfessorOaksLab_RivalBattleBulbasaur
    GoTo PalletTown_ProfessorOaksLab_RivalBattleSquirtle
    End

PalletTown_ProfessorOaksLab_RivalApproachFromCharmander:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalApproachFromCharmander
    WaitMovement
    SetVar VAR_0x8006, 9
    Return

PalletTown_ProfessorOaksLab_RivalApproachFromBulbasaur:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalApproachFromBulbasaur
    WaitMovement
    SetVar VAR_0x8006, 7
    Return

PalletTown_ProfessorOaksLab_RivalApproachFromSquirtle:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalApproachFromSquirtle
    WaitMovement
    SetVar VAR_0x8006, 7
    Return

// Walks the rival along his row from x = VAR_0x8006 to x = VAR_0x8004.
PalletTown_ProfessorOaksLab_RivalWalkAlongRow:
    GoToIfLt VAR_0x8006, VAR_0x8004, PalletTown_ProfessorOaksLab_RivalStepEast
    GoToIfGt VAR_0x8006, VAR_0x8004, PalletTown_ProfessorOaksLab_RivalStepWest
    Return

PalletTown_ProfessorOaksLab_RivalStepEast:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_WalkEast
    WaitMovement
    AddVar VAR_0x8006, 1
    GoTo PalletTown_ProfessorOaksLab_RivalWalkAlongRow
    End

PalletTown_ProfessorOaksLab_RivalStepWest:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_WalkWest
    WaitMovement
    SubVar VAR_0x8006, 1
    GoTo PalletTown_ProfessorOaksLab_RivalWalkAlongRow
    End

PalletTown_ProfessorOaksLab_RivalBattleSquirtle:
    StartTrainerBattle TRAINER_RIVAL_OAKS_LAB_SQUIRTLE
    GoTo PalletTown_ProfessorOaksLab_EndRivalBattle
    End

PalletTown_ProfessorOaksLab_RivalBattleBulbasaur:
    StartTrainerBattle TRAINER_RIVAL_OAKS_LAB_BULBASAUR
    GoTo PalletTown_ProfessorOaksLab_EndRivalBattle
    End

PalletTown_ProfessorOaksLab_RivalBattleCharmander:
    StartTrainerBattle TRAINER_RIVAL_OAKS_LAB_CHARMANDER
    GoTo PalletTown_ProfessorOaksLab_EndRivalBattle
    End

// Win or lose, the story goes on, as in FRLG.
PalletTown_ProfessorOaksLab_EndRivalBattle:
    BufferPlayerName 0
    BufferRivalName 1
    CheckWonBattle VAR_RESULT
    CallIfEq VAR_RESULT, FALSE, PalletTown_ProfessorOaksLab_RivalWon
    HealParty
    Message PalletTown_ProfessorOaksLab_Text_RivalGoToughenMyMon
    WaitButton
    CloseMessage
    Call PalletTown_ProfessorOaksLab_RivalExit
    RemoveObject LOCALID_RIVAL
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    Common_FadeToDefaultMusic
    SetVar VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 4
    SetFlag FLAG_BEAT_RIVAL_IN_OAKS_LAB
    ReleaseAll
    End

PalletTown_ProfessorOaksLab_RivalWon:
    Message Text_RivalVictory
    WaitButton
    Return

// The rival steps aside from above the player, goes down to the row in front
// of the door, along it and out.
PalletTown_ProfessorOaksLab_RivalExit:
    SetVar VAR_0x8006, VAR_0x8004
    GoToIfGt VAR_0x8004, 7, PalletTown_ProfessorOaksLab_RivalExitWest
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalExitEast
    WaitMovement
    AddVar VAR_0x8006, 1
    GoTo PalletTown_ProfessorOaksLab_RivalExitToDoor
    End

PalletTown_ProfessorOaksLab_RivalExitWest:
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalExitWest
    WaitMovement
    SubVar VAR_0x8006, 1
PalletTown_ProfessorOaksLab_RivalExitToDoor:
    SetVar VAR_0x8004, 8
    Call PalletTown_ProfessorOaksLab_RivalWalkAlongRow
    ApplyMovement LOCALID_RIVAL, PalletTown_ProfessorOaksLab_Movement_RivalLeave
    ApplyMovement LOCALID_PLAYER, PalletTown_ProfessorOaksLab_Movement_PlayerWatchRivalLeave
    WaitMovement
    Return

PalletTown_ProfessorOaksLab_Aide1:
    NPCMessage PalletTown_ProfessorOaksLab_Text_StudyAsOaksAide
    End

PalletTown_ProfessorOaksLab_Aide2:
    NPCMessage PalletTown_ProfessorOaksLab_Text_StudyAsOaksAide
    End

PalletTown_ProfessorOaksLab_Aide3:
    NPCMessage PalletTown_ProfessorOaksLab_Text_OakIsAuthorityOnMons
    End

PalletTown_ProfessorOaksLab_Computer:
    EventMessage PalletTown_ProfessorOaksLab_Text_EmailMessage
    End

PalletTown_ProfessorOaksLab_Bookshelf:
    EventMessage Text_Bookshelf
    End

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakEnter:
    WalkNormalNorth 6
    WalkOnSpotNormalSouth
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_PlayerEnter:
    WalkNormalNorth 6
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalReact:
    WalkOnSpotNormalNorth 2
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_FaceNorth:
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_FaceSouth:
    WalkOnSpotFastSouth
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WalkNorth:
    WalkNormalNorth
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WalkEast:
    WalkNormalEast
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WalkWest:
    WalkNormalWest
    EndMovement

// From (7, 7) to below each ball, the player standing below another.
    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalkToCharmander:
    WalkNormalEast 2
    WalkNormalNorth 3
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalkToBulbasaur:
    WalkNormalNorth 3
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalkToSquirtle:
    WalkNormalNorth 3
    WalkNormalEast
    WalkOnSpotFastNorth
    EndMovement

// From below his ball to row 8, passing Oak at (8, 6).
    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachFromCharmander:
    WalkNormalSouth 4
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachFromBulbasaur:
    WalkNormalSouth 4
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachFromSquirtle:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth 3
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalExitEast:
    WalkNormalEast
    WalkNormalSouth 4
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalExitWest:
    WalkNormalWest
    WalkNormalSouth 4
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalLeave:
    WalkNormalSouth
    SetInvisible
    EndMovement

    .balign 4, 0
PalletTown_ProfessorOaksLab_Movement_PlayerWatchRivalLeave:
    WalkOnSpotFastSouth
    EndMovement
