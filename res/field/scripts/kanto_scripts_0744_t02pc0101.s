#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0455_t02pc0101.h"
#include "res/field/events/kanto_events_453_t02pc0101.h"


    ScriptEntry scr_seq_T02PC0101_000
    ScriptEntry scr_seq_T02PC0101_001
    ScriptEntry scr_seq_T02PC0101_002
    ScriptEntry scr_seq_T02PC0101_003
    ScriptEntryEnd

scr_seq_T02PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T02PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_TALKED_TO_MOM_ABOUT_NATIONAL_DEX_PROGRESS
    GoToIf 0, _003C
    Message msg_0455_T02PC0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

_003C:
    Message msg_0455_T02PC0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T02PC0101_002:
    NPCMessage msg_0455_T02PC0101_00002
    End

scr_seq_T02PC0101_003:
    NPCMessage msg_0455_T02PC0101_00003
    End

    .balign 4, 0
