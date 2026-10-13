#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pallet_town_rivals_house.h"
#include "res/field/events/kanto_events_456_t01r0201.h"

// FRLG's PalletTown_RivalsHouse on HGSS's Blue's house. Daisy's Town Map
// waits for Oak's Parcel.


    ScriptEntry PalletTown_RivalsHouse_Daisy
    ScriptEntryEnd

PalletTown_RivalsHouse_Daisy:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferRivalName 1
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

    .balign 4, 0
PalletTown_RivalsHouse_Movement_DaisyFaceEast:
    FaceEast
    EndMovement
