#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0372_r28r0101.h"
#include "res/field/events/kanto_events_462_r28r0101.h"


    ScriptEntry scr_seq_R28R0101_000
    ScriptEntry scr_seq_R28R0101_001
    ScriptEntry scr_seq_R28R0101_002
    ScriptEntryEnd

scr_seq_R28R0101_002:
    ApplyMovement obj_R28R0101_gsgirl1, _0020
    WaitMovement
    SetVar VAR_UNUSED_0x408F, 1
    End

    .balign 4, 0
_0020:
    FaceSouth
    EmoteExclamationMark
    EndMovement

scr_seq_R28R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_HEARTHOME_CITY_PINK_CRYSTAL
    GoToIf 1, _012A
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0060
    ApplyMovement obj_R28R0101_gsgirl1, _0140
    GoTo _009E

_0060:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _007B
    ApplyMovement obj_R28R0101_gsgirl1, _014C
    GoTo _009E

_007B:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0096
    ApplyMovement obj_R28R0101_gsgirl1, _0158
    GoTo _009E

_0096:
    ApplyMovement obj_R28R0101_gsgirl1, _0164

_009E:
    WaitMovement
    Message msg_0372_R28R0101_00000
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00BE
    ApplyMovement obj_R28R0101_gsgirl1, _0164
    GoTo _00FC

_00BE:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _00D9
    ApplyMovement obj_R28R0101_gsgirl1, _0158
    GoTo _00FC

_00D9:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00F4
    ApplyMovement obj_R28R0101_gsgirl1, _014C
    GoTo _00FC

_00F4:
    ApplyMovement obj_R28R0101_gsgirl1, _0140

_00FC:
    WaitMovement
    Message msg_0372_R28R0101_00001
    SetVar VAR_0x8004, ITEM_TM47
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0135
    Common_GiveItemQuantity
    SetFlag FLAG_RECEIVED_HEARTHOME_CITY_PINK_CRYSTAL

_012A:
    Message msg_0372_R28R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0135:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0
_0140:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement

    .balign 4, 0
_014C:
    Delay8
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
_0158:
    Delay8
    WalkOnSpotNormalEast
    EndMovement

    .balign 4, 0
_0164:
    Delay8
    WalkOnSpotNormalSouth
    EndMovement

scr_seq_R28R0101_001:
    PlayCry SPECIES_FEAROW
    NPCMessage msg_0372_R28R0101_00003
    WaitCry
    End

    .balign 4, 0
