#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0483_t06.h"
#include "res/field/events/kanto_events_051_t06.h"


    ScriptEntry scr_seq_T06_000_StandIn
    ScriptEntry scr_seq_T06_001
    ScriptEntry scr_seq_T06_002
    ScriptEntry scr_seq_T06_003
    ScriptEntry scr_seq_T06_004
    ScriptEntry scr_seq_T06_005
    ScriptEntry scr_seq_T06_006
    ScriptEntry scr_seq_T06_007
    ScriptEntry scr_seq_T06_008
    ScriptEntry scr_seq_T06_009
    ScriptEntry scr_seq_T06_010_StandIn
    ScriptEntry scr_seq_T06_011_StandIn
    ScriptEntry scr_seq_T06_012_StandIn
    ScriptEntry scr_seq_T06_013_StandIn
    ScriptEntryEnd

scr_seq_T06_009:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _004B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_004B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0066
    ClearFlag FLAG_UNK_0x0041
    GoTo _0081

_0066:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _007D
    ClearFlag FLAG_UNK_0x0041
    GoTo _0081

_007D:
    SetFlag FLAG_UNK_0x0041

_0081:
    SetVar VAR_ROUTE_207_COUNTERPART_TRIGGER_STATE, 0
    End

scr_seq_T06_001:
    NPCMessage msg_0483_T06_00000
    End

scr_seq_T06_002:
    NPCMessage msg_0483_T06_00003
    End

scr_seq_T06_003:
    NPCMessage msg_0483_T06_00001
    End

scr_seq_T06_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MACHOP
    Message msg_0483_T06_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06_005:
    DrawSignpostInstantMessage msg_0483_T06_00010, SIGNPOST_TYPE_MAP, 6
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T06_006:
    ShowLandmarkSign msg_0483_T06_00011
    End

scr_seq_T06_007:
    ShowLandmarkSign msg_0483_T06_00012
    End

scr_seq_T06_008:
    ShowLandmarkSign msg_0483_T06_00013
    End

scr_seq_T06_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0483_T06_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06_010_StandIn:
    End

scr_seq_T06_011_StandIn:
    End

scr_seq_T06_012_StandIn:
    End

scr_seq_T06_013_StandIn:
    End

    .balign 4, 0
