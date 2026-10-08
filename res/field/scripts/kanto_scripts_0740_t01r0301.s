#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0451_t01r0301.h"
#include "res/field/events/kanto_events_457_t01r0301.h"


    ScriptEntry scr_seq_T01R0301_000_StandIn
    ScriptEntry scr_seq_T01R0301_001
    ScriptEntry scr_seq_T01R0301_002
    ScriptEntry scr_seq_T01R0301_003
    ScriptEntry scr_seq_T01R0301_004
    ScriptEntry scr_seq_T01R0301_005
    ScriptEntry scr_seq_T01R0301_006
    ScriptEntry scr_seq_T01R0301_007_StandIn
    ScriptEntry scr_seq_T01R0301_008_StandIn
    ScriptEntry scr_seq_T01R0301_009_StandIn
    ScriptEntry scr_seq_T01R0301_010
    ScriptEntryEnd

scr_seq_T01R0301_010:
    CompareVar VAR_SPEAR_PILLAR_STATE, 3
    GoToIf 1, _0057
    CompareVar VAR_SPEAR_PILLAR_STATE, 4
    GoToIf 1, _0057
    CompareVar VAR_SPEAR_PILLAR_STATE, 5
    GoToIf 1, _0057
    End

_0057:
    SetFlag FLAG_RECEIVED_ETERNA_CITY_SOUTH_HOUSE_UPGRADE
    SetFlag FLAG_TALKED_TO_ROUTE_213_GRUNT_M
    SetFlag FLAG_RECEIVED_SOLACEON_TOWN_EAST_HOUSE_SEAL_CASE
    SetVar VAR_SPEAR_PILLAR_STATE, 6
    End

scr_seq_T01R0301_006:
    LockAll
    ApplyMovement LOCALID_PLAYER, _00C8
    WaitMovement
    BufferPlayerName 0
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, _Gen001_Female
    Message msg_0451_T01R0301_00039
    GoTo _Gen001_Done
_Gen001_Female:
    Message msg_0451_T01R0301_00040
_Gen001_Done:
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _00E0
    WaitMovement
    Message msg_0451_T01R0301_00041
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _00F4
    ApplyMovement LOCALID_PLAYER, _00D0
    WaitMovement
    Message msg_0451_T01R0301_00042
    WaitButton
    CloseMessage
    SetVar VAR_SPEAR_PILLAR_STATE, 2
    ReleaseAll
    End

    .balign 4, 0
_00C8:
    WalkNormalNorth 5
    EndMovement

    .balign 4, 0
_00D0:
    Delay8 2
    WalkNormalNorth 3
    WalkNormalWest 2
    EndMovement

    .balign 4, 0
_00E0:
    FaceNorth
    Delay8 4
    FaceSouth
    Delay8 3
    EndMovement

    .balign 4, 0
_00F4:
    WalkNormalNorth
    WalkNormalWest 3
    FaceEast
    EndMovement

scr_seq_T01R0301_001:
    NPCMessage msg_0451_T01R0301_00033
    End

scr_seq_T01R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0451_T01R0301_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, _Gen010_Female
    Message msg_0451_T01R0301_00037
    GoTo _Gen010_Done
_Gen010_Female:
    Message msg_0451_T01R0301_00038
_Gen010_Done:
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_000_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_007_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0451_T01R0301_00045
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_008_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0451_T01R0301_00044
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T01R0301_009_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0451_T01R0301_00043
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
