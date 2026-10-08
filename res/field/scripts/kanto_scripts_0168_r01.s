#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0319_r01.h"
#include "res/field/events/kanto_events_006_r01.h"


    ScriptEntry scr_seq_R01_000_StandIn
    ScriptEntry scr_seq_R01_001
    ScriptEntry scr_seq_R01_002
    ScriptEntryEnd

scr_seq_R01_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _001F
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_001F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0050
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0050
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0050
    SetFlag FLAG_UNK_0x0041
    End

_0050:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_R01_002:
    DrawSignpostInstantMessage msg_0319_R01_00000, SIGNPOST_TYPE_ARROW, 4
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R01_000_StandIn:
    End

    .balign 4, 0
