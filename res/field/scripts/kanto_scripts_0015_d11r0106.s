#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0053_d11r0106.h"
#include "res/field/events/kanto_events_412_d11r0106.h"


    ScriptEntry scr_seq_D11R0106_000_StandIn
    ScriptEntry scr_seq_D11R0106_001
    ScriptEntry scr_seq_D11R0106_002_StandIn
    ScriptEntry scr_seq_D11R0106_003_StandIn
    ScriptEntry scr_seq_D11R0106_004_StandIn
    ScriptEntry scr_seq_D11R0106_005_StandIn
    ScriptEntry scr_seq_D11R0106_006_StandIn
    ScriptEntry scr_seq_D11R0106_007_StandIn
    ScriptEntry scr_seq_D11R0106_008
    ScriptEntry scr_seq_D11R0106_009_StandIn
    ScriptEntryEnd

scr_seq_D11R0106_008:
    CheckFlag FLAG_CAUGHT_AZELF
    CallIf 1, _00D4
    CheckFlag FLAG_CAUGHT_UXIE
    CallIf 1, _00E2
    CheckFlag FLAG_WOKE_UP_CANALAVE_CITY_SAILOR_ELDRITCH_HOUSE_LITTLE_BOY
    CallIf 1, _00F0
    End

_00D4:
    SetPosition obj_D11R0106_gsassistantm, 21, 0, 14, DIR_WEST
    Return

_00E2:
    SetPosition obj_D11R0106_gsassistantm_3, 9, 0, 13, DIR_NORTH
    Return

_00F0:
    SetPosition obj_D11R0106_assistantm, 15, 0, 16, DIR_SOUTH
    Return

scr_seq_D11R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckBadgeAcquired 6, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04B6
    Message msg_0053_D11R0106_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End

_04B6:
    Message msg_0053_D11R0106_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_003_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_004_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_005_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_006_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0053_D11R0106_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_D11R0106_009_StandIn:
    End

    .balign 4, 0
