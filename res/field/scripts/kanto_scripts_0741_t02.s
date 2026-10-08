#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0452_t02.h"
#include "res/field/events/kanto_events_047_t02.h"


    ScriptEntry scr_seq_T02_000
    ScriptEntry scr_seq_T02_001
    ScriptEntry scr_seq_T02_002
    ScriptEntry scr_seq_T02_003
    ScriptEntry scr_seq_T02_004
    ScriptEntry scr_seq_T02_005
    ScriptEntry scr_seq_T02_006
    ScriptEntry scr_seq_T02_007
    ScriptEntry scr_seq_T02_008
    ScriptEntry scr_seq_T02_009_StandIn
    ScriptEntry scr_seq_T02_010
    ScriptEntry scr_seq_T02_011_StandIn
    ScriptEntryEnd

scr_seq_T02_008:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0043
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0043:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _005E
    ClearFlag FLAG_UNK_0x0041
    GoTo _0079

_005E:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0075
    ClearFlag FLAG_UNK_0x0041
    GoTo _0079

_0075:
    SetFlag FLAG_UNK_0x0041

_0079:
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_GYM_STATUE
    GoToIf 1, _008E
    SetFlag FLAG_RECEIVED_HEARTHOME_CITY_GYM_STATUE
    SetVar VAR_JUBILIFE_LOOKER_PAL_PAD_STATE, 1

_008E:
    End

scr_seq_T02_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0452_T02_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00D7
    Message msg_0452_T02_00001
    GoTo _00DA

_00D7:
    Message msg_0452_T02_00002

_00DA:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T02_001:
    NPCMessage msg_0452_T02_00003
    End

scr_seq_T02_010:
    NPCMessage msg_0452_T02_00004
    End

scr_seq_T02_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_CAUGHT_DARKRAI
    GoToIf 1, _0147
    Message msg_0452_T02_00005
    SetVar VAR_0x8004, ITEM_TM85
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0152
    Common_GiveItemQuantity
    SetFlag FLAG_CAUGHT_DARKRAI

_0147:
    Message msg_0452_T02_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0152:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

scr_seq_T02_003:
    NPCMessage msg_0452_T02_00007
    End

scr_seq_T02_004:
    DrawSignpostInstantMessage msg_0452_T02_00008, SIGNPOST_TYPE_MAP, 2
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T02_005:
    ShowLandmarkSign msg_0452_T02_00009
    End

scr_seq_T02_006:
    ShowLandmarkSign msg_0452_T02_00010
    End

scr_seq_T02_007:
    ShowLandmarkSign msg_0452_T02_00011
    End

scr_seq_T02_009_StandIn:
    End

scr_seq_T02_011_StandIn:
    End

    .balign 4, 0
