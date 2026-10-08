#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0323_r02r0301.h"
#include "res/field/events/kanto_events_373_r02r0301.h"


    ScriptEntry scr_seq_R02R0301_000
    ScriptEntry scr_seq_R02R0301_001
    ScriptEntryEnd

scr_seq_R02R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckFlag FLAG_RECEIVED_GRAND_LAKE_VALOR_LAKEFRONT_EAST_HOUSE_WHITE_FLUTE
    GoToIf 1, _004D
    BufferPlayerName 0
    GetPlayerGender VAR_RESULT
    GoToIfEq VAR_RESULT, GENDER_FEMALE, _Gen001_Female
    Message msg_0323_R02R0301_00000
    GoTo _Gen001_Done
_Gen001_Female:
    Message msg_0323_R02R0301_00001
_Gen001_Done:
    SetVar VAR_0x8004, ITEM_SACRED_ASH
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, _0058
    Common_GiveItemQuantity
    SetFlag FLAG_RECEIVED_GRAND_LAKE_VALOR_LAKEFRONT_EAST_HOUSE_WHITE_FLUTE

_004D:
    Message msg_0323_R02R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End

_0058:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

scr_seq_R02R0301_001:
    NPCMessage msg_0323_R02R0301_00003
    End

    .balign 4, 0
