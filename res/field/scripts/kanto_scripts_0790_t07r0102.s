#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0495_t07r0102.h"
#include "res/field/events/kanto_events_328_t07r0102.h"


    ScriptEntry scr_seq_T07R0102_000
    ScriptEntry scr_seq_T07R0102_001
    ScriptEntry scr_seq_T07R0102_002
    ScriptEntry scr_seq_T07R0102_003
    ScriptEntry scr_seq_T07R0102_004
    ScriptEntry scr_seq_T07R0102_005_StandIn
    ScriptEntry scr_seq_T07R0102_006
    ScriptEntry scr_seq_T07R0102_007_StandIn
    ScriptEntryEnd

scr_seq_T07R0102_006:
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    GoToIf 0, _0033
    ClearFlag FLAG_RECEIVED_PASTORIA_CITY_MIDDLE_HOUSE_MACHO_BRACE
    End

_0033:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _004E
    ClearFlag FLAG_UNK_0x0041
    GoTo _0052

_004E:
    SetFlag FLAG_UNK_0x0041

_0052:
    End

scr_seq_T07R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 18
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_18
    ReleaseAll
    End

scr_seq_T07R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 19
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_19
    ReleaseAll
    End

scr_seq_T07R0102_002:
    NPCMessage msg_0495_T07R0102_00000
    End

scr_seq_T07R0102_003:
    NPCMessage msg_0495_T07R0102_00001
    End

scr_seq_T07R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0495_T07R0102_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07R0102_005_StandIn:
    End

scr_seq_T07R0102_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0495_T07R0102_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
