#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0516_t08r0201.h"
#include "res/field/events/kanto_events_432_t08r0201.h"


    ScriptEntry scr_seq_T08R0201_000_StandIn
    ScriptEntry scr_seq_T08R0201_001_StandIn
    ScriptEntry scr_seq_T08R0201_002_StandIn
    ScriptEntry scr_seq_T08R0201_003_StandIn
    ScriptEntry scr_seq_T08R0201_004
    ScriptEntry scr_seq_T08R0201_005
    ScriptEntry scr_seq_T08R0201_006
    ScriptEntry scr_seq_T08R0201_007
    ScriptEntry scr_seq_T08R0201_008
    ScriptEntry scr_seq_T08R0201_009_StandIn
    ScriptEntryEnd

_0062:
    CompareVar VAR_EXITED_DISTORTION_WORLD_STATE, 2000
    GoToIf 1, _0079
    BufferPlayerName 1
    BufferNumber 2, VAR_EXITED_DISTORTION_WORLD_STATE
    Return

_0079:
    BufferRivalName 1
    BufferNumber 2, VAR_EXITED_DISTORTION_WORLD_STATE
    Return

scr_seq_T08R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0444
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0439
    GoTo _042E

_042E:
    Message msg_0516_T08R0201_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0439:
    Message msg_0516_T08R0201_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0444:
    Message msg_0516_T08R0201_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08R0201_005:
    BufferPlayerName 0
    NPCMessage msg_0516_T08R0201_00044
    End

scr_seq_T08R0201_006:
    NPCMessage msg_0516_T08R0201_00045
    End

scr_seq_T08R0201_007:
    NPCMessage msg_0516_T08R0201_00033
    End

scr_seq_T08R0201_008:
    Call _0062
    NPCMessage msg_0516_T08R0201_00025
    End

scr_seq_T08R0201_000_StandIn:
    End

scr_seq_T08R0201_001_StandIn:
    End

scr_seq_T08R0201_002_StandIn:
    End

scr_seq_T08R0201_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0516_T08R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T08R0201_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0516_T08R0201_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
