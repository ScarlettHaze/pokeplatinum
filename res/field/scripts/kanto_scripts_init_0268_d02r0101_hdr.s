#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_D02R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D02R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_ACUITY_LAKEFRONT_STATE, 0, 1
    InitScriptFrameTableEnd
    InitScriptEnd
