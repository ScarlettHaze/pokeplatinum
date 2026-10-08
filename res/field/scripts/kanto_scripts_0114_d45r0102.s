#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0131_d45r0102.h"
#include "res/field/events/kanto_events_269_d45r0102.h"


    ScriptEntry scr_seq_D45R0102_000_StandIn
    ScriptEntry scr_seq_D45R0102_001_StandIn
    ScriptEntry scr_seq_D45R0102_002
    ScriptEntry scr_seq_D45R0102_003
    ScriptEntryEnd

scr_seq_D45R0102_002:
    End

scr_seq_D45R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_ROUTE_203_RIVAL_STATE, 4
    GoToIf 4, _0404
    Message msg_0131_D45R0102_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0404:
    Message msg_0131_D45R0102_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D45R0102_000_StandIn:
    End

scr_seq_D45R0102_001_StandIn:
    End

    .balign 4, 0
