#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0522_t10r0101.h"
#include "res/field/events/kanto_events_271_t10r0101.h"


    ScriptEntry scr_seq_T10R0101_000
    ScriptEntry scr_seq_T10R0101_001
    ScriptEntry scr_seq_T10R0101_002
    ScriptEntry scr_seq_T10R0101_003
    ScriptEntry scr_seq_T10R0101_004
    ScriptEntry scr_seq_T10R0101_005
    ScriptEntry scr_seq_T10R0101_006_StandIn
    ScriptEntry scr_seq_T10R0101_007_StandIn
    ScriptEntry scr_seq_T10R0101_008
    ScriptEntryEnd

scr_seq_T10R0101_005:
    SetFlag FLAG_COULD_NOT_RECEIVE_OREBURGH_MINE_B1F_FLAME_PLATE
    SetFlag FLAG_EXAMINED_CELESTIC_TOWN_CAVE_PAINTING
    SetFlag FLAG_TALKED_TO_LAKE_ACUITY_LOW_WATER_RIVAL
    SetFlag FLAG_RECEIVED_NATIONAL_DEX_DIPLOMA
    ClearFlag FLAG_DELIVERED_OLD_CHARM
    ClearFlag FLAG_LAKE_VALOR_EXPLODED
    ClearFlag FLAG_RECEIVED_LOCAL_DEX_DIPLOMA
    ClearFlag FLAG_UNUSED_0x00AE
    ClearFlag FLAG_HIDE_OREBURGH_CITY_RIVAL
    ClearFlag FLAG_HIDE_ROUTE_212_BLOCKADE
    ClearFlag FLAG_HIDE_JUBILIFE_CITY_LOOKER
    ClearFlag FLAG_UNUSED_0x0187
    CompareVar VAR_DUMMY_0x4083, 1
    GoToIf 3, _00AC
    CheckFlag FLAG_DAILY_0x0B5C
    GoToIf 1, _00AC
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _008B
    SetVar VAR_JUBILIFE_CITY_STATE, 1
    GoTo _00AA

_008B:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00A4
    SetVar VAR_JUBILIFE_CITY_STATE, 1
    GoTo _00AA

_00A4:
    SetVar VAR_JUBILIFE_CITY_STATE, 0

_00AA:
    End

_00AC:
    End

scr_seq_T10R0101_001:
    NPCMessage msg_0522_T10R0101_00000
    End

scr_seq_T10R0101_002:
    NPCMessage msg_0522_T10R0101_00001
    End

scr_seq_T10R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ABRA
    Message msg_0522_T10R0101_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T10R0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T10R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 13
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_13
    ReleaseAll
    End

scr_seq_T10R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 4, _0293
    Message msg_0522_T10R0101_00005
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _027D
    ApplyMovement obj_T10R0101_counterm, _02A0
    GoTo _0287

_027D:
    ApplyMovement obj_T10R0101_counterm, _02B0
    WaitMovement

_0287:
    WaitMovement
    SetVar VAR_MAP_LOCAL_0x05, 1
    ReleaseAll
    End

_0293:
    Message msg_0522_T10R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
_02A0:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement

    .balign 4, 0
_02B0:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement

scr_seq_T10R0101_006_StandIn:
    End

scr_seq_T10R0101_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0522_T10R0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
