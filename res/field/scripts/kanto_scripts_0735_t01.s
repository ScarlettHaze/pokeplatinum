#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0446_t01.h"
#include "res/field/events/kanto_events_046_t01.h"


    ScriptEntry scr_seq_T01_000
    ScriptEntry scr_seq_T01_001
    ScriptEntry scr_seq_T01_002
    ScriptEntry scr_seq_T01_003
    ScriptEntry scr_seq_T01_004
    ScriptEntry scr_seq_T01_005
    ScriptEntry scr_seq_T01_006_StandIn
    ScriptEntry scr_seq_T01_007
    ScriptEntryEnd

scr_seq_T01_007:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0033
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0033:
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_RED_CRYSTAL
    GoToIf 1, _0044
    GoTo _004A

_0044:
    SetVar VAR_MT_CORONET_1F_SOUTH_STATE, 0

_004A:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _007B
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _007B
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _007B
    SetFlag FLAG_UNK_0x0041
    End

_007B:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_T01_000:
    NPCMessage msg_0446_T01_00000
    End

scr_seq_T01_001:
    NPCMessage msg_0446_T01_00001
    End

scr_seq_T01_002:
    DrawSignpostInstantMessage msg_0446_T01_00002, SIGNPOST_TYPE_MAP, 1
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T01_003:
    ShowLandmarkSign msg_0446_T01_00003
    End

scr_seq_T01_004:
    ShowLandmarkSign msg_0446_T01_00004
    End

scr_seq_T01_005:
    ShowLandmarkSign msg_0446_T01_00005
    End

scr_seq_T01_006_StandIn:
    End

    .balign 4, 0
