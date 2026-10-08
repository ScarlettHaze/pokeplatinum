#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0335_r06r0201.h"
#include "res/field/events/kanto_events_346_r06r0201.h"


    ScriptEntry scr_seq_R06R0201_000
    ScriptEntryEnd

scr_seq_R06R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _0024
    Message msg_0335_R06R0201_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0024:
    Message msg_0335_R06R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
