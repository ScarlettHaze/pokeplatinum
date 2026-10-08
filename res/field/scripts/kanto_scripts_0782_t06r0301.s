#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0488_t06r0301.h"
#include "res/field/events/kanto_events_319_t06r0301.h"


    ScriptEntry scr_seq_T06R0301_000
    ScriptEntry scr_seq_T06R0301_001
    ScriptEntry scr_seq_T06R0301_002_StandIn
    ScriptEntry scr_seq_T06R0301_003
    ScriptEntry scr_seq_T06R0301_004
    ScriptEntry scr_seq_T06R0301_005
    ScriptEntry scr_seq_T06R0301_006
    ScriptEntry scr_seq_T06R0301_007
    ScriptEntryEnd

scr_seq_T06R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_UNUSED_0x016C
    GoToIf 0, _0044
    BufferPlayerName 0
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, _Gen001_Female
    Message msg_0488_T06R0301_00004
    GoTo _Gen001_Done
_Gen001_Female:
    Message msg_0488_T06R0301_00005
_Gen001_Done:
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0044:
    Message msg_0488_T06R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _009E
    Message msg_0488_T06R0301_00001
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0093
    Common_GiveItemQuantity
    SetFlag FLAG_UNUSED_0x016C
    Message msg_0488_T06R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0093:
    Message msg_0488_T06R0301_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End

_009E:
    Message msg_0488_T06R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06R0301_001:
    NPCMessage msg_0488_T06R0301_00008
    End

scr_seq_T06R0301_003:
    NPCMessage msg_0488_T06R0301_00014
    End

scr_seq_T06R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BAYLEEF
    Message msg_0488_T06R0301_00016
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_T06R0301_007:
    CheckFlag FLAG_DEFEATED_FLINT
    GoToIf 1, _0198
    NPCMessage msg_0488_T06R0301_00015
    End

_0198:
    End

scr_seq_T06R0301_005:
    NPCMessage msg_0488_T06R0301_00017
    End

scr_seq_T06R0301_006:
    NPCMessage msg_0488_T06R0301_00018
    End

scr_seq_T06R0301_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0488_T06R0301_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
