#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0526_t10r0501.h"
#include "res/field/events/kanto_events_275_t10r0501.h"


    ScriptEntry scr_seq_T10R0501_000
    ScriptEntry scr_seq_T10R0501_001_StandIn
    ScriptEntry scr_seq_T10R0501_002
    ScriptEntryEnd

scr_seq_T10R0501_002:
    CheckFlag FLAG_UNUSED_0x0187
    GoToIf 1, _0023
    ShowObject obj_T10R0501_leag_door2_2
    ShowObject obj_T10R0501_leag_door2_3
    End

_0023:
    End

scr_seq_T10R0501_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0060
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_RECEIVED_NATIONAL_DEX_DIPLOMA
    AddObject obj_T10R0501_babyboy1_11
    SetVar VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End

    .balign 4, 0
_0060:
    WalkNormalNorth 6
    EndMovement

scr_seq_T10R0501_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0526_T10R0501_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
