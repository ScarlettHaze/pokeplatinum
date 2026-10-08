#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0535_t11r0601.h"
#include "res/field/events/kanto_events_357_t11r0601.h"


    ScriptEntry scr_seq_T11R0601_000
    ScriptEntry scr_seq_T11R0601_001
    ScriptEntry scr_seq_T11R0601_002
    ScriptEntry scr_seq_T11R0601_003
    ScriptEntry scr_seq_T11R0601_004_StandIn
    ScriptEntry scr_seq_T11R0601_005
    ScriptEntry scr_seq_T11R0601_006_StandIn
    ScriptEntry scr_seq_T11R0601_007_StandIn
    ScriptEntry scr_seq_T11R0601_008
    ScriptEntryEnd

scr_seq_T11R0601_005:
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _008D
    End

_008D:
    SetPosition obj_T11R0601_policeman, 12, 0, 7, DIR_EAST
    End

scr_seq_T11R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _00B9
    Message msg_0535_T11R0601_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

_00B9:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00D7
    Message msg_0535_T11R0601_00005
    WaitButton
    CloseMessage
    GoTo _00E6

_00D7:
    Message msg_0535_T11R0601_00007
    CloseMessage
    ApplyMovement obj_T11R0601_policeman, _00EC
    WaitMovement

_00E6:
    ReleaseAll
    End

    .balign 4, 0
_00EC:
    FaceEast
    EndMovement

scr_seq_T11R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN
    GoToIf 1, _028E
    Message msg_0535_T11R0601_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

_028E:
    Message msg_0535_T11R0601_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0601_002:
    NPCMessage msg_0535_T11R0601_00010
    End

scr_seq_T11R0601_003:
    NPCMessage msg_0535_T11R0601_00011
    End

scr_seq_T11R0601_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0535_T11R0601_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T11R0601_004_StandIn:
    End

scr_seq_T11R0601_006_StandIn:
    End

scr_seq_T11R0601_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0535_T11R0601_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
