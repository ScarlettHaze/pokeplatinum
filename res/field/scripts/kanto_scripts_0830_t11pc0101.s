#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0532_t11pc0101.h"
#include "res/field/events/kanto_events_363_t11pc0101.h"


    ScriptEntry scr_seq_T11PC0101_000
    ScriptEntry scr_seq_T11PC0101_001
    ScriptEntry scr_seq_T11PC0101_002
    ScriptEntry scr_seq_T11PC0101_003
    ScriptEntryEnd

scr_seq_T11PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T11PC0101_001:
    NPCMessage msg_0532_T11PC0101_00000
    End

scr_seq_T11PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _004F
    Message msg_0532_T11PC0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_004F:
    Message msg_0532_T11PC0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11PC0101_003:
    NPCMessage msg_0532_T11PC0101_00003
    End

    .balign 4, 0
