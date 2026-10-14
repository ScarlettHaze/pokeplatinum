#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_route22.h"
#include "res/field/events/kanto_events_024_r22.h"

// FRLG's Route 22 on HGSS's: the rival's first ambush. Coming in from
// Viridian, the player crosses x 319 on one of rows 266 to 268; the rival
// comes up from the south-west to the tile beside them.
//
// VAR_MAP_SCENE_ROUTE22 is FRLG's: 1 once the player has a Pokédex, 2 after
// this battle. The later battle (3) isn't ported yet.


    ScriptEntry Route22_Rival
    ScriptEntry Route22_LeagueGateSign
    ScriptEntry Route22_EarlyRivalTrigger
    ScriptEntryEnd

Route22_Rival:
    End

Route22_LeagueGateSign:
    ShowLandmarkSign Route22_Text_LeagueGateSign
    End

Route22_EarlyRivalTrigger:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    PlayMusic SEQ_GS_E_RIVAL1_sseq
    SetObjectEventPos LOCALID_RIVAL, 315, VAR_0x8005
    ClearFlag FLAG_HIDE_ROUTE_22_RIVAL
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_RIVAL, Route22_Movement_RivalApproach
    ApplyMovement LOCALID_PLAYER, Route22_Movement_PlayerFaceRival
    WaitMovement
    BufferPlayerName 0
    BufferRivalName 1
    Message Route22_Text_EarlyRivalIntro
    WaitButton
    CloseMessage
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_BULBASAUR, Route22_EarlyRivalCharmander
    GoToIfEq VAR_PLAYER_STARTER, SPECIES_SQUIRTLE, Route22_EarlyRivalBulbasaur
    GoTo Route22_EarlyRivalSquirtle
    End

Route22_EarlyRivalSquirtle:
    StartTrainerBattle TRAINER_FRLG_RIVAL_ROUTE22_EARLY_SQUIRTLE
    GoTo Route22_EarlyRivalAfterBattle
    End

Route22_EarlyRivalBulbasaur:
    StartTrainerBattle TRAINER_FRLG_RIVAL_ROUTE22_EARLY_BULBASAUR
    GoTo Route22_EarlyRivalAfterBattle
    End

Route22_EarlyRivalCharmander:
    StartTrainerBattle TRAINER_FRLG_RIVAL_ROUTE22_EARLY_CHARMANDER
    GoTo Route22_EarlyRivalAfterBattle
    End

Route22_EarlyRivalAfterBattle:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, Route22_BlackOut
    BufferPlayerName 0
    BufferRivalName 1
    Message Route22_Text_EarlyRivalPostBattle
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_RIVAL, Route22_Movement_RivalExit
    WaitMovement
    RemoveObject LOCALID_RIVAL
    Common_FadeToDefaultMusic
    SetVar VAR_MAP_SCENE_ROUTE22, 2
    ReleaseAll
    End

Route22_BlackOut:
    BlackOutFromBattle
    ReleaseAll
    End

    .balign 4, 0
Route22_Movement_RivalApproach:
    WalkNormalEast 3
    EndMovement

    .balign 4, 0
Route22_Movement_PlayerFaceRival:
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
Route22_Movement_RivalExit:
    WalkNormalWest 3
    WalkNormalSouth 4
    SetInvisible
    EndMovement
