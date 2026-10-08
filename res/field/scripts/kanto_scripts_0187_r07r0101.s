#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0337_r07r0101.h"
#include "res/field/events/kanto_events_445_r07r0101.h"


    ScriptEntry scr_seq_R07R0101_000
    ScriptEntryEnd

scr_seq_R07R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _0024
    Message msg_0337_R07R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0024:
    Message msg_0337_R07R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
