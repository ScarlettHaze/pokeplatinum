#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0463_t03pc0101.h"
#include "res/field/events/kanto_events_428_t03pc0101.h"


    ScriptEntry scr_seq_T03PC0101_000
    ScriptEntry scr_seq_T03PC0101_001_StandIn
    ScriptEntry scr_seq_T03PC0101_002
    ScriptEntry scr_seq_T03PC0101_003
    ScriptEntry scr_seq_T03PC0101_004
    ScriptEntryEnd

scr_seq_T03PC0101_000:
    SetVar VAR_0x8007, 0
    CallCommonScript 0x7D2
    End

scr_seq_T03PC0101_002:
    NPCMessage msg_0463_T03PC0101_00000
    End

scr_seq_T03PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_JIGGLYPUFF
    Message msg_0463_T03PC0101_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T03PC0101_004:
    NPCMessage msg_0463_T03PC0101_00002
    End

scr_seq_T03PC0101_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0463_T03PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
