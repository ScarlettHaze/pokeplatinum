#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0351_r14.h"
#include "res/field/events/kanto_events_019_r14.h"


    ScriptEntry scr_seq_R14_000_StandIn
    ScriptEntry scr_seq_R14_001
    ScriptEntry scr_seq_R14_002_StandIn
    ScriptEntry scr_seq_R14_003
    ScriptEntry scr_seq_R14_004
    ScriptEntry scr_seq_R14_005_StandIn
    ScriptEntryEnd

scr_seq_R14_001:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _002B
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_002B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _004F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _004F
    SetFlag FLAG_UNK_0x0041
    End

_004F:
    ClearFlag FLAG_UNK_0x0041
    End

scr_seq_R14_003:
    BufferPlayerName 0
    NPCMessage msg_0351_R14_00007
    End

scr_seq_R14_004:
    BufferPlayerName 0
    NPCMessage msg_0351_R14_00007
    End

scr_seq_R14_000_StandIn:
    End

scr_seq_R14_002_StandIn:
    End

scr_seq_R14_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0351_R14_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
