#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0530_t11fs0101.h"
#include "res/field/events/kanto_events_365_t11fs0101.h"


    ScriptEntry scr_seq_T11FS0101_000
    ScriptEntry scr_seq_T11FS0101_001
    ScriptEntry scr_seq_T11FS0101_002
    ScriptEntry scr_seq_T11FS0101_003
    ScriptEntryEnd

scr_seq_T11FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 1
    PokeMartCommon
    ReleaseAll
    End

scr_seq_T11FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVar VAR_0x8004, 15
    PokeMartSpecialties MART_SPECIALTIES_ID_KANTO_15
    ReleaseAll
    End

scr_seq_T11FS0101_002:
    NPCMessage msg_0530_T11FS0101_00000
    End

scr_seq_T11FS0101_003:
    NPCMessage msg_0530_T11FS0101_00001
    End

    .balign 4, 0
