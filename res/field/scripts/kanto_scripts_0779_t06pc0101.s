#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0486_t06pc0101.h"
#include "res/field/events/kanto_events_315_t06pc0101.h"


    ScriptEntry scr_seq_T06PC0101_000
    ScriptEntry scr_seq_T06PC0101_001
    ScriptEntry scr_seq_T06PC0101_002
    ScriptEntry scr_seq_T06PC0101_003
    ScriptEntryEnd

scr_seq_T06PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T06PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_NORTHEAST_HOUSE_GREEN_SCARF
    GoToIf 1, _003C
    Message msg_0486_T06PC0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_003C:
    Message msg_0486_T06PC0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06PC0101_002:
    NPCMessage msg_0486_T06PC0101_00002
    End

scr_seq_T06PC0101_003:
    NPCMessage msg_0486_T06PC0101_00003
    End

    .balign 4, 0
