#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_museum_1f.h"
#include "res/field/events/kanto_events_424_t03r0101.h"

// FRLG's Pewter Museum of Science on HGSS's, which is one floor: FRLG's
// second floor (the space exhibit and the Moon Stone) shares it. The ticket
// is checked at (10, 16), the one way in from the door. The fossils show
// their Pokémon, as in FRLG.


    ScriptEntry PewterCity_Museum_1F_Receptionist
    ScriptEntry PewterCity_Museum_1F_OldMan
    ScriptEntry PewterCity_Museum_1F_OldAmberScientist
    ScriptEntry PewterCity_Museum_1F_Scientist2
    ScriptEntry PewterCity_Museum_2F_Scientist
    ScriptEntry PewterCity_Museum_2F_Man
    ScriptEntry PewterCity_Museum_2F_OldMan
    ScriptEntry PewterCity_Museum_2F_LittleGirl
    ScriptEntry PewterCity_Museum_2F_BaldingMan
    ScriptEntry PewterCity_Museum_1F_AerodactylFossil
    ScriptEntry PewterCity_Museum_1F_KabutopsFossil
    ScriptEntry PewterCity_Museum_2F_MoonStone
    ScriptEntry PewterCity_Museum_2F_SpaceShuttle
    ScriptEntry PewterCity_Museum_1F_PokemonJournalBrock
    ScriptEntry PewterCity_Museum_1F_EntranceTrigger
    ScriptEntryEnd

PewterCity_Museum_1F_EntranceTrigger:
    LockAll
    ShowMoney 20, 2
    Message PewterCity_Museum_1F_Text_Its50YForChildsTicket
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, PewterCity_Museum_1F_DeclineTicket
    GoToIfNotEnoughMoney 50, PewterCity_Museum_1F_NotEnoughMoney
    RemoveMoney 50
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message PewterCity_Museum_1F_Text_Right50YThankYou
    WaitButton
    CloseMessage
    HideMoney
    SetVar VAR_MAP_SCENE_PEWTER_CITY_MUSEUM_1F, 1
    ReleaseAll
    End

PewterCity_Museum_1F_DeclineTicket:
    Message PewterCity_Museum_1F_Text_ComeAgain
    GoTo PewterCity_Museum_1F_SendBack
    End

PewterCity_Museum_1F_NotEnoughMoney:
    Message PewterCity_Museum_1F_Text_DontHaveEnoughMoney
PewterCity_Museum_1F_SendBack:
    WaitButton
    CloseMessage
    HideMoney
    ApplyMovement LOCALID_PLAYER, PewterCity_Museum_1F_Movement_WalkSouth
    WaitMovement
    ReleaseAll
    End

PewterCity_Museum_1F_Receptionist:
    NPCMessage PewterCity_Museum_1F_Text_PleaseEnjoyYourself
    End

PewterCity_Museum_1F_OldMan:
    NPCMessage PewterCity_Museum_1F_Text_ShouldBeGratefulForLongLife
    End

PewterCity_Museum_1F_OldAmberScientist:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_GOT_OLD_AMBER, PewterCity_Museum_1F_AlreadyGotOldAmber
    Message PewterCity_Museum_1F_Text_WantYouToGetAmberExamined
    WaitButton
    GoToIfCannotFitItem ITEM_OLD_AMBER, 1, VAR_RESULT, PewterCity_Museum_1F_NoRoomForOldAmber
    AddItem ITEM_OLD_AMBER, 1, VAR_RESULT
    SetFlag FLAG_GOT_OLD_AMBER
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA4_sseq
    Message PewterCity_Museum_1F_Text_ReceivedOldAmberFromMan
    WaitFanfare
    GoTo PewterCity_Museum_1F_MessageEnd
    End

PewterCity_Museum_1F_NoRoomForOldAmber:
    Message PewterCity_Museum_1F_Text_DontHaveSpaceForThis
    GoTo PewterCity_Museum_1F_MessageEnd
    End

PewterCity_Museum_1F_AlreadyGotOldAmber:
    Message PewterCity_Museum_1F_Text_GetOldAmberChecked
    GoTo PewterCity_Museum_1F_MessageEnd
    End

PewterCity_Museum_1F_MessageEnd:
    WaitButton
    CloseMessage
    ReleaseAll
    End

PewterCity_Museum_1F_Scientist2:
    NPCMessage PewterCity_Museum_1F_Text_WeHaveTwoFossilsOnExhibit
    End

PewterCity_Museum_2F_Scientist:
    NPCMessage PewterCity_Museum_1F_Text_RunningSpaceExhibitThisMonth
    End

PewterCity_Museum_2F_Man:
    NPCMessage PewterCity_Museum_1F_Text_WhatsSpecialAboutMoonStone
    End

PewterCity_Museum_2F_OldMan:
    NPCMessage PewterCity_Museum_1F_Text_BoughtColorTVForMoonLanding
    End

PewterCity_Museum_2F_LittleGirl:
    NPCMessage PewterCity_Museum_1F_Text_AskedDaddyToCatchPikachu
    End

PewterCity_Museum_2F_BaldingMan:
    NPCMessage PewterCity_Museum_1F_Text_PikachuSoonIPromise
    End

PewterCity_Museum_1F_AerodactylFossil:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    DrawPokemonPreview SPECIES_AERODACTYL, GENDER_MALE
    Message PewterCity_Museum_1F_Text_AerodactylFossil
    GoTo PewterCity_Museum_1F_FossilEnd
    End

PewterCity_Museum_1F_KabutopsFossil:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    DrawPokemonPreview SPECIES_KABUTOPS, GENDER_MALE
    Message PewterCity_Museum_1F_Text_KabutopsFossil
PewterCity_Museum_1F_FossilEnd:
    WaitButton
    RemovePokemonPreview
    CloseMessage
    ReleaseAll
    End

PewterCity_Museum_2F_MoonStone:
    EventMessage PewterCity_Museum_1F_Text_MeteoriteThatFellOnMtMoon
    End

PewterCity_Museum_2F_SpaceShuttle:
    EventMessage PewterCity_Museum_1F_Text_SpaceShuttle
    End

PewterCity_Museum_1F_PokemonJournalBrock:
    EventMessage PokemonJournal_Text_SpecialFeatureBrock
    End

    .balign 4, 0
PewterCity_Museum_1F_Movement_WalkSouth:
    WalkNormalSouth
    EndMovement
