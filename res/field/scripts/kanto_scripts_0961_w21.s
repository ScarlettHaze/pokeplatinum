#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0743_w21.h"
#include "res/field/events/kanto_events_090_w21.h"


    ScriptEntry scr_seq_W21_000_StandIn
    ScriptEntry scr_seq_W21_001
    ScriptEntryEnd

scr_seq_W21_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _001B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_001B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _003F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _003F
    SetFlag FLAG_UNK_0x0041
    End

_003F:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_W21_000_StandIn:
    End

    .balign 4, 0
