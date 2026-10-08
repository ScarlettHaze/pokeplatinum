#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0003_everywhere.h"
#include "res/field/events/kanto_events_406_d03r0103.h"


    ScriptEntry scr_seq_D03R0103_000_StandIn
    ScriptEntry scr_seq_D03R0103_001
    ScriptEntryEnd

scr_seq_D03R0103_001:
    CheckFlag FLAG_UNUSED_0x0122
    GoToIf 1, _0017
    End

_0017:
    SetFlag FLAG_DUMMY_0x00EB
    RemoveObject obj_D03R0103_tsure_poke_static_mewtwo
    ClearFlag FLAG_UNUSED_0x0122
    End

scr_seq_D03R0103_000_StandIn:
    End

    .balign 4, 0
