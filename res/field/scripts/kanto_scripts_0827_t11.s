#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0529_t11.h"
#include "res/field/events/kanto_events_056_t11.h"


    ScriptEntry scr_seq_T11_000
    ScriptEntry scr_seq_T11_001
    ScriptEntry scr_seq_T11_002
    ScriptEntry scr_seq_T11_003
    ScriptEntry scr_seq_T11_004
    ScriptEntry scr_seq_T11_005
    ScriptEntry scr_seq_T11_006
    ScriptEntry scr_seq_T11_007
    ScriptEntry scr_seq_T11_008
    ScriptEntry scr_seq_T11_009
    ScriptEntry scr_seq_T11_010
    ScriptEntry scr_seq_T11_011
    ScriptEntry scr_seq_T11_012
    ScriptEntry scr_seq_T11_013
    ScriptEntry scr_seq_T11_014_StandIn
    ScriptEntry scr_seq_T11_015_StandIn
    ScriptEntry scr_seq_T11_016
    ScriptEntryEnd

scr_seq_T11_016:
    CheckFlag FLAG_HIDE_CELESTIC_TOWN_ELDER
    GoToIf 0, _0055
    ClearFlag FLAG_HIDE_CELESTIC_TOWN_ELDER

_0055:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0066
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0066:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _00BF
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _00BF
    SetFlag FLAG_UNK_0x0041
    SetFlag FLAG_RECEIVED_FLOWER_SHOP_SPRAYDUCK
    End

_00B5:
    ClearFlag FLAG_UNK_0x0041
    SetFlag FLAG_RECEIVED_FLOWER_SHOP_SPRAYDUCK
    End

_00BF:
    SetFlag FLAG_UNK_0x0041
    ClearFlag FLAG_RECEIVED_FLOWER_SHOP_SPRAYDUCK
    End

scr_seq_T11_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_ROUTE_225_HOUSE_FRESH_WATER
    GoToIf 1, _03BE
    Message msg_0529_T11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

_03BE:
    Message msg_0529_T11_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11_000:
    NPCMessage msg_0529_T11_00000
    End

scr_seq_T11_001:
    NPCMessage msg_0529_T11_00001
    End

scr_seq_T11_003:
    NPCMessage msg_0529_T11_00004
    End

scr_seq_T11_004:
    NPCMessage msg_0529_T11_00005
    End

scr_seq_T11_005:
    NPCMessage msg_0529_T11_00006
    End

scr_seq_T11_006:
    NPCMessage msg_0529_T11_00007
    End

scr_seq_T11_007:
    NPCMessage msg_0529_T11_00008
    End

scr_seq_T11_008:
    ShowLandmarkSign msg_0529_T11_00009
    End

scr_seq_T11_009:
    DrawSignpostInstantMessage msg_0529_T11_00010, SIGNPOST_TYPE_MAP, 10
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T11_010:
    ShowLandmarkSign msg_0529_T11_00011
    End

scr_seq_T11_011:
    ShowLandmarkSign msg_0529_T11_00012
    End

scr_seq_T11_012:
    ShowLandmarkSign msg_0529_T11_00013
    End

scr_seq_T11_013:
    ShowLandmarkSign msg_0529_T11_00014
    End

scr_seq_T11_014_StandIn:
    End

scr_seq_T11_015_StandIn:
    End

    .balign 4, 0
