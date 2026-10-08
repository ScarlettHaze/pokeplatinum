#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0347_r11r0101.h"
#include "res/field/events/kanto_events_380_r11r0101.h"


    ScriptEntry scr_seq_R11R0101_000
    ScriptEntry scr_seq_R11R0101_001
    ScriptEntryEnd

scr_seq_R11R0101_000:
    SetVar VAR_ROUTE_207_COUNTERPART_TRIGGER_STATE, 0
    End

scr_seq_R11R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_PASTORIA_CITY_NORTHEAST_HOUSE_PINK_SCARF
    GoToIf 1, _0030
    Message msg_0347_R11R0101_00000

_0028:
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0030:
    Message msg_0347_R11R0101_00001
    GoTo _0028

    .balign 4, 0
