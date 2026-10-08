#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0360_r22.h"
#include "res/field/events/kanto_events_024_r22.h"


    ScriptEntry scr_seq_R22_000_StandIn
    ScriptEntry scr_seq_R22_001
    ScriptEntry scr_seq_R22_002
    ScriptEntry scr_seq_R22_003_StandIn
    ScriptEntry scr_seq_R22_004
    ScriptEntryEnd

scr_seq_R22_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0027
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0027:
    CompareVar VAR_ROUTE_203_RIVAL_STATE, 1
    GoToIf 1, _005E
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0058
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0058
    SetFlag FLAG_UNK_0x0041
    End

_0058:
    ClearFlag FLAG_UNK_0x0041
    End

_005E:
    SetFlag FLAG_UNK_0x0041
    End

scr_seq_R22_004:
    CompareVar VAR_ROUTE_203_RIVAL_STATE, 1
    GoToIf 1, _0073
    End

_0073:
    SetPosition obj_R22_sakaki, 275, 1, 266, DIR_WEST
    SetPosition obj_R22_gsrivel, 278, 1, 266, DIR_WEST
    SetPosition obj_R22_var_1, 280, 1, 280, DIR_EAST
    End

scr_seq_R22_002:
    ShowLandmarkSign msg_0360_R22_00000
    End

scr_seq_R22_000_StandIn:
    End

scr_seq_R22_003_StandIn:
    End

    .balign 4, 0
