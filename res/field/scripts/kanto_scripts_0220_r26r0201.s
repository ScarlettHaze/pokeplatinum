#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0367_r26r0201.h"
#include "res/field/events/kanto_events_268_r26r0201.h"


    ScriptEntry scr_seq_R26R0201_000
    ScriptEntryEnd

scr_seq_R26R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0367_R26R0201_00000
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0049
    Message msg_0367_R26R0201_00001
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0049
    Message msg_0367_R26R0201_00002
    WaitButton
    CloseMessage

_0049:
    ReleaseAll
    End

    .balign 4, 0
