#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_city_school.h"
#include "res/text/bank/menu_entries.h"
#include "res/field/events/kanto_events_450_t02r0301.h"

// FRLG's Trainer school on HGSS's Trainer House: the teacher at the front, a
// pupil at the middle table with her notebook, the blackboard and the journal
// on the back wall.


    ScriptEntry ViridianCity_School_Woman
    ScriptEntry ViridianCity_School_Lass
    ScriptEntry ViridianCity_School_Notebook
    ScriptEntry ViridianCity_School_Blackboard
    ScriptEntry ViridianCity_School_PokemonJournal
    ScriptEntryEnd

ViridianCity_School_Woman:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message ViridianCity_School_Text_ReadBlackboardCarefully
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_WOMAN, ViridianCity_School_Movement_FaceSouth
    WaitMovement
    ReleaseAll
    End

ViridianCity_School_Lass:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message ViridianCity_School_Text_TryingToMemorizeNotes
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_LASS, ViridianCity_School_Movement_FaceNorth
    WaitMovement
    ReleaseAll
    End

ViridianCity_School_Notebook:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message ViridianCity_School_Text_NotebookFirstPage
    WaitButton
    Message ViridianCity_School_Text_TurnThePage
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, ViridianCity_School_StopReadingNotebook
    Message ViridianCity_School_Text_NotebookSecondPage
    WaitButton
    Message ViridianCity_School_Text_TurnThePage
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, ViridianCity_School_StopReadingNotebook
    Message ViridianCity_School_Text_NotebookThirdPage
    WaitButton
    Message ViridianCity_School_Text_TurnThePage
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_NO, ViridianCity_School_StopReadingNotebook
    Message ViridianCity_School_Text_NotebookFourthPage
    WaitButton
    CloseMessage
    ApplyMovement LOCALID_LASS, ViridianCity_School_Movement_FaceNorth
    WaitMovement
    Message ViridianCity_School_Text_HeyDontLookAtMyNotes
    WaitButton
ViridianCity_School_StopReadingNotebook:
    CloseMessage
    ReleaseAll
    End

ViridianCity_School_Blackboard:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message ViridianCity_School_Text_BlackboardListsStatusProblems
    WaitButton
ViridianCity_School_ChooseBlackboardTopic:
    Message ViridianCity_School_Text_ReadWhichTopic
    InitGlobalTextMenu 7, 2, 0, VAR_RESULT
    AddMenuEntryImm MenuEntries_Text_Status_Asleep, 0
    AddMenuEntryImm MenuEntries_Text_Status_Poisoned, 1
    AddMenuEntryImm MenuEntries_Text_Status_Paralyzed, 2
    AddMenuEntryImm MenuEntries_Text_Status_Burned, 3
    AddMenuEntryImm MenuEntries_Text_Status_Frozen, 4
    AddMenuEntryImm MenuEntries_Text_Exit, 5
    ShowMenuMultiColumn 2
    GoToIfEq VAR_RESULT, 0, ViridianCity_School_ReadSleep
    GoToIfEq VAR_RESULT, 1, ViridianCity_School_ReadPoison
    GoToIfEq VAR_RESULT, 2, ViridianCity_School_ReadParalysis
    GoToIfEq VAR_RESULT, 3, ViridianCity_School_ReadBurn
    GoToIfEq VAR_RESULT, 4, ViridianCity_School_ReadFreeze
    CloseMessage
    ReleaseAll
    End

ViridianCity_School_ReadSleep:
    Message ViridianCity_School_Text_ExplainSleep
    GoTo ViridianCity_School_ReadTopic
    End

ViridianCity_School_ReadPoison:
    Message ViridianCity_School_Text_ExplainPoison
    GoTo ViridianCity_School_ReadTopic
    End

ViridianCity_School_ReadParalysis:
    Message ViridianCity_School_Text_ExplainParalysis
    GoTo ViridianCity_School_ReadTopic
    End

ViridianCity_School_ReadBurn:
    Message ViridianCity_School_Text_ExplainBurn
    GoTo ViridianCity_School_ReadTopic
    End

ViridianCity_School_ReadFreeze:
    Message ViridianCity_School_Text_ExplainFreeze
ViridianCity_School_ReadTopic:
    WaitButton
    GoTo ViridianCity_School_ChooseBlackboardTopic
    End

ViridianCity_School_PokemonJournal:
    EventMessage PokemonJournal_Text_SpecialFeatureProfOak
    End

    .balign 4, 0
ViridianCity_School_Movement_FaceNorth:
    WalkOnSpotFastNorth
    EndMovement

    .balign 4, 0
ViridianCity_School_Movement_FaceSouth:
    WalkOnSpotFastSouth
    EndMovement
