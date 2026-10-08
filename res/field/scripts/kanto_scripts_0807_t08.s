#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0512_t08.h"
#include "res/field/events/kanto_events_053_t08.h"


    ScriptEntry scr_seq_T08_000
    ScriptEntry scr_seq_T08_001
    ScriptEntry scr_seq_T08_002
    ScriptEntry scr_seq_T08_003
    ScriptEntry scr_seq_T08_004
    ScriptEntry scr_seq_T08_005
    ScriptEntry scr_seq_T08_006_StandIn
    ScriptEntry scr_seq_T08_007
    ScriptEntry scr_seq_T08_008_StandIn
    ScriptEntry scr_seq_T08_009
    ScriptEntryEnd

scr_seq_T08_007:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _003B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_003B:
    ClearFlag FLAG_RECEIVED_HEARTHOME_CITY_GLOBE
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0063
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0063
    SetFlag FLAG_UNK_0x0041
    End

_0063:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_T08_000:
    NPCMessage msg_0512_T08_00000
    End

scr_seq_T08_001:
    NPCMessage msg_0512_T08_00001
    End

scr_seq_T08_002:
    NPCMessage msg_0512_T08_00002
    End

scr_seq_T08_009:
    DrawSignpostInstantMessage msg_0512_T08_00003, SIGNPOST_TYPE_MAP, 8
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T08_003:
    ShowLandmarkSign msg_0512_T08_00004
    End

scr_seq_T08_004:
    ShowLandmarkSign msg_0512_T08_00005
    End

scr_seq_T08_005:
    ShowLandmarkSign msg_0512_T08_00006
    End

scr_seq_T08_006_StandIn:
    End

scr_seq_T08_008_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0512_T08_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
