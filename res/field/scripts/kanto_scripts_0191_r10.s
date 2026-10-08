#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0341_r10.h"
#include "res/field/events/kanto_events_015_r10.h"


    ScriptEntry scr_seq_R10_000_StandIn
    ScriptEntry scr_seq_R10_001_StandIn
    ScriptEntry scr_seq_R10_002_StandIn
    ScriptEntry scr_seq_R10_003_StandIn
    ScriptEntry scr_seq_R10_004
    ScriptEntry scr_seq_R10_005
    ScriptEntry scr_seq_R10_006
    ScriptEntryEnd

scr_seq_R10_004:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _002B
    End

_002B:
    SetFlag FLAG_UNK_0x004E
    RemoveObject obj_R10_tsure_poke_static_zapdos
    ClearFlag FLAG_UNUSED_0x0122
    End

scr_seq_R10_005:
    ShowLandmarkSign msg_0341_R10_00008
    End

scr_seq_R10_006:
    ShowLandmarkSign msg_0341_R10_00009
    End

scr_seq_R10_000_StandIn:
    End

scr_seq_R10_001_StandIn:
    End

scr_seq_R10_002_StandIn:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0341_R10_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End

scr_seq_R10_003_StandIn:
    End

    .balign 4, 0
