#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0369_r27.h"
#include "res/field/events/kanto_events_028_r27.h"


    ScriptEntry scr_seq_R27_000
    ScriptEntry scr_seq_R27_001
    ScriptEntry scr_seq_R27_002
    ScriptEntry scr_seq_R27_003_StandIn
    ScriptEntry scr_seq_R27_004
    ScriptEntryEnd

scr_seq_R27_000:
    NPCMessage msg_0369_R27_00001
    End

scr_seq_R27_001:
    LockAll
    ApplyMovement obj_R27_gsbigman, _00A8
    WaitMovement
    Message msg_0369_R27_00000
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    AddVar VAR_MAP_LOCAL_0x00, 672
    AddVar VAR_MAP_LOCAL_0x01, 0
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _006F
    ApplyMovement obj_R27_gsbigman, _00C4
    GoTo _0092

_006F:
    CompareVar VAR_MAP_LOCAL_0x01, 403
    GoToIf 5, _008A
    ApplyMovement obj_R27_gsbigman, _00B0
    GoTo _0092

_008A:
    ApplyMovement obj_R27_gsbigman, _00B8

_0092:
    WaitMovement
    Message msg_0369_R27_00001
    WaitButton
    CloseMessage
    ReleaseAll
    SetVar VAR_UNUSED_0x406D, 1
    End

    .balign 4, 0
_00A8:
    EmoteExclamationMark
    EndMovement

    .balign 4, 0
_00B0:
    WalkNormalWest 4
    EndMovement

    .balign 4, 0
_00B8:
    WalkNormalSouth
    WalkNormalWest 4
    EndMovement

    .balign 4, 0
_00C4:
    WalkNormalNorth
    WalkNormalWest 4
    EndMovement

scr_seq_R27_002:
    ShowLandmarkSign msg_0369_R27_00002
    End

scr_seq_R27_004:
    DrawSignpostInstantMessage msg_0369_R27_00003, SIGNPOST_TYPE_ARROW, 5
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_R27_003_StandIn:
    End

    .balign 4, 0
