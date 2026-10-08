#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0003_everywhere.h"
#include "res/field/events/kanto_events_411_d11r0105.h"


    ScriptEntry scr_seq_D11R0105_000_StandIn
    ScriptEntry scr_seq_D11R0105_001
    ScriptEntryEnd

scr_seq_D11R0105_001:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _0017
    End

_0017:
    SetFlag FLAG_TALKED_TO_DR_FOOTSTEP
    RemoveObject obj_D11R0105_tsure_poke_static_articuno
    ClearFlag FLAG_UNUSED_0x0122
    End

scr_seq_D11R0105_000_StandIn:
    End

    .balign 4, 0
