#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0365_r26.h"
#include "res/field/events/kanto_events_027_r26.h"


    ScriptEntry scr_seq_R26_000_StandIn
    ScriptEntry scr_seq_R26_001
    ScriptEntry scr_seq_R26_002
    ScriptEntry scr_seq_R26_003
    ScriptEntryEnd

scr_seq_R26_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0023
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0023:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0047
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0047
    SetFlag FLAG_UNK_0x0041
    End

_0047:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_R26_002:
    ShowLandmarkSign msg_0365_R26_00000
    End

scr_seq_R26_003:
    DrawSignpostInstantMessage msg_0365_R26_00001, SIGNPOST_TYPE_ARROW, 6
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R26_000_StandIn:
    End

    .balign 4, 0
