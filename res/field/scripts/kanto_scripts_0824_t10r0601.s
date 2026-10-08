#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0527_t10r0601.h"
#include "res/field/events/kanto_events_276_t10r0601.h"


    ScriptEntry scr_seq_T10R0601_000_StandIn
    ScriptEntry scr_seq_T10R0601_001
    ScriptEntry scr_seq_T10R0601_002
    ScriptEntryEnd

scr_seq_T10R0601_001:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0048
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_POKEMON_LEAGUE_DOOR_GUARD_MOVED_AWAY
    AddObject obj_T10R0601_babyboy1_11
    SetVar VAR_UNUSED_0x40AF, 1
    ReleaseAll
    End

    .balign 4, 0
_0048:
    WalkNormalNorth 6
    EndMovement

scr_seq_T10R0601_002:
    SetFlag FLAG_POKEMON_LEAGUE_DOOR_GUARD_MOVED_AWAY
    SetVar VAR_UNUSED_0x40AF, 0
    End

scr_seq_T10R0601_000_StandIn:
    End

    .balign 4, 0
