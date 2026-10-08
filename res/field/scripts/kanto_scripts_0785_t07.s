#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0491_t07.h"
#include "res/field/events/kanto_events_052_t07.h"


    ScriptEntry scr_seq_T07_000
    ScriptEntry scr_seq_T07_001
    ScriptEntry scr_seq_T07_002
    ScriptEntry scr_seq_T07_003
    ScriptEntry scr_seq_T07_004
    ScriptEntry scr_seq_T07_005
    ScriptEntry scr_seq_T07_006
    ScriptEntry scr_seq_T07_007
    ScriptEntry scr_seq_T07_008
    ScriptEntry scr_seq_T07_009
    ScriptEntry scr_seq_T07_010
    ScriptEntry scr_seq_T07_011
    ScriptEntry scr_seq_T07_012
    ScriptEntry scr_seq_T07_013
    ScriptEntry scr_seq_T07_014
    ScriptEntry scr_seq_T07_015_StandIn
    ScriptEntry scr_seq_T07_016_StandIn
    ScriptEntry scr_seq_T07_017
    ScriptEntry scr_seq_T07_018_StandIn
    ScriptEntryEnd

scr_seq_T07_000:
    NPCMessage msg_0491_T07_00000
    End

scr_seq_T07_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_POLIWRATH
    Message msg_0491_T07_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07_002:
    NPCMessage msg_0491_T07_00002
    End

scr_seq_T07_003:
    NPCMessage msg_0491_T07_00003
    End

scr_seq_T07_004:
    NPCMessage msg_0491_T07_00004
    End

scr_seq_T07_005:
    NPCMessage msg_0491_T07_00005
    End

scr_seq_T07_006:
    NPCMessage msg_0491_T07_00006
    End

scr_seq_T07_007:
    NPCMessage msg_0491_T07_00007
    End

scr_seq_T07_008:
    NPCMessage msg_0491_T07_00008
    End

scr_seq_T07_009:
    DrawSignpostInstantMessage msg_0491_T07_00030, SIGNPOST_TYPE_MAP, 7
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End

scr_seq_T07_010:
    ShowLandmarkSign msg_0491_T07_00031
    End

scr_seq_T07_011:
    ShowLandmarkSign msg_0491_T07_00032
    End

scr_seq_T07_012:
    ShowLandmarkSign msg_0491_T07_00033
    End

scr_seq_T07_013:
    ShowLandmarkSign msg_0491_T07_00034
    End

scr_seq_T07_014:
    ShowScrollingSign msg_0491_T07_00035
    End

_0302:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVar VAR_MAP_LOCAL_0x05, 1
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00009
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00010
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00011
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00012
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00013
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00014
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00015
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00016
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00017
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
_045C:
    WalkOnSpotNormalEast
    EndMovement

    .balign 4, 0
_0464:
    WalkOnSpotNormalWest
    EndMovement

scr_seq_T07_017:
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _0500
    GoTo _0302
    End

_0500:
    NPCMessage msg_0491_T07_00029
    End

scr_seq_T07_015_StandIn:
    End

scr_seq_T07_016_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0491_T07_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T07_018_StandIn:
    End

    .balign 4, 0
