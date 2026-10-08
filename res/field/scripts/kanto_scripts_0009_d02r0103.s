#include "macros/scrcmd.inc"
#include "res/text/bank/kanto_msg_0050_d02r0103.h"
#include "res/field/events/kanto_events_404_d02r0103.h"


    ScriptEntry scr_seq_D02R0103_000
    ScriptEntry scr_seq_D02R0103_001
    ScriptEntry scr_seq_D02R0103_002_StandIn
    ScriptEntryEnd

scr_seq_D02R0103_000:
    ShowLandmarkSign msg_0050_D02R0103_00000
    End

scr_seq_D02R0103_001:
    NPCMessage msg_0050_D02R0103_00001
    End

scr_seq_D02R0103_002_StandIn:
    End

    .balign 4, 0
