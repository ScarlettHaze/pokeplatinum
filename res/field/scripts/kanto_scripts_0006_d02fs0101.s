#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0048_d02fs0101.h"
#include "res/field/events/kanto_events_470_d02fs0101.h"


    ScriptEntry scr_seq_D02FS0101_000
    ScriptEntry scr_seq_D02FS0101_001
    ScriptEntryEnd

scr_seq_D02FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetFlag FLAG_MET_CRESSELIA
    Message msg_0048_D02FS0101_00001
    SetVar VAR_0x8004, 27
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_27
    ClearFlag FLAG_MET_CRESSELIA
    ReleaseAll
    End

scr_seq_D02FS0101_000:
    NPCMessage msg_0048_D02FS0101_00000
    End

    .balign 4, 0
