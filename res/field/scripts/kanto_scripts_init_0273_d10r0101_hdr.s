#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 1
    InitScriptEntry_OnFrameTable scr_seq_D10R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_D10R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_SANDGEM_TOWN_STATE, 0, 2
    InitScriptFrameTableEnd
    InitScriptEnd
