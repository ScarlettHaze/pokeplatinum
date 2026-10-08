#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0524_t10r0301.h"
#include "res/field/events/kanto_events_273_t10r0301.h"


    ScriptEntry scr_seq_T10R0301_000
    ScriptEntry scr_seq_T10R0301_001_StandIn
    ScriptEntry scr_seq_T10R0301_002
    ScriptEntryEnd

scr_seq_T10R0301_002:
    CheckFlag FLAG_HIDE_ROUTE_212_BLOCKADE
    GoToIf 1, _0023
    ShowObject obj_T10R0301_stop
    ShowObject obj_T10R0301_stop_2
    End

_0023:
    End

scr_seq_T10R0301_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0060
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_EXAMINED_CELESTIC_TOWN_CAVE_PAINTING
    AddObject obj_T10R0301_babyboy1_11
    SetVar VAR_MAP_LOCAL_0x01, 1
    ReleaseAll
    End

    .balign 4, 0
_0060:
    WalkNormalNorth 6
    EndMovement

scr_seq_T10R0301_001_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0524_T10R0301_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
