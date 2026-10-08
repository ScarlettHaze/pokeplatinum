#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0525_t10r0401.h"
#include "res/field/events/kanto_events_274_t10r0401.h"


    ScriptEntry scr_seq_T10R0401_000
    ScriptEntry scr_seq_T10R0401_001_StandIn
    ScriptEntry scr_seq_T10R0401_002
    ScriptEntryEnd

scr_seq_T10R0401_002:
    CheckFlag FLAG_HIDE_JUBILIFE_CITY_LOOKER
    GoToIf 1, _0023
    ShowObject obj_T10R0401_leag_door2_2
    ShowObject obj_T10R0401_leag_door2_3
    End

_0023:
    End

scr_seq_T10R0401_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0060
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_TALKED_TO_LAKE_ACUITY_LOW_WATER_RIVAL
    AddObject obj_T10R0401_babyboy1_11
    SetVar VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End

    .balign 4, 0
_0060:
    WalkNormalNorth 6
    EndMovement

scr_seq_T10R0401_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0525_T10R0401_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
