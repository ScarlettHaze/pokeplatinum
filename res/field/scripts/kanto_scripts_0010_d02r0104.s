#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0051_d02r0104.h"
#include "res/field/events/kanto_events_465_d02r0104.h"


    ScriptEntry scr_seq_D02R0104_000
    ScriptEntry scr_seq_D02R0104_001
    ScriptEntry scr_seq_D02R0104_002_StandIn
    ScriptEntry scr_seq_D02R0104_003_StandIn
    ScriptEntry scr_seq_D02R0104_004
    ScriptEntry scr_seq_D02R0104_005
    ScriptEntryEnd

scr_seq_D02R0104_000:
    SetFlag FLAG_CAUGHT_REGIGIGAS
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _003B
    GoTo _0060

_003B:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0054
    GoTo _007D

_0054:
    SetVar VAR_FIGHT_AREA_STATE, 1
    SetFlag FLAG_AWAKENED_REGIGIGAS

_005E:
    End

_0060:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _009A
    SetVar VAR_FIGHT_AREA_STATE, 1
    SetFlag FLAG_AWAKENED_REGIGIGAS
    End

_007D:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _009A
    SetVar VAR_FIGHT_AREA_STATE, 1
    SetFlag FLAG_AWAKENED_REGIGIGAS
    End

_009A:
    SetVar VAR_FIGHT_AREA_STATE, 0
    ClearFlag FLAG_AWAKENED_REGIGIGAS
    End

scr_seq_D02R0104_005:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00C3
    GoTo _0113

_00C3:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00DC
    GoTo _012A

_00DC:
    GoTo _00E2

_00E2:
    CompareVar VAR_FIGHT_AREA_STATE, 1
    GoToIf 1, _0141
    SetFlag FLAG_AWAKENED_REGIGIGAS
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_2
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_3
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_4
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_5
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_6
    SetVar VAR_FIGHT_AREA_STATE, 1
    End

_0113:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _0141
    GoTo _00E2

_012A:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _0141
    GoTo _00E2

_0141:
    End

scr_seq_D02R0104_001:
    ShowLandmarkSign msg_0051_D02R0104_00001
    End

scr_seq_D02R0104_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0051_D02R0104_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D02R0104_002_StandIn:
    End

scr_seq_D02R0104_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0051_D02R0104_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
