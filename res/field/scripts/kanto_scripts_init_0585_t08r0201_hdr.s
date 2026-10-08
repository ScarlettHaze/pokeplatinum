#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 1
    InitScriptEntry_OnFrameTable scr_seq_T08R0201_map_scripts_2
    InitScriptEntryEnd
scr_seq_T08R0201_map_scripts_2:
    InitScriptGoToIfEqual VAR_SANDGEM_TOWN_STATE, 1, 2
    InitScriptGoToIfEqual VAR_SANDGEM_TOWN_STATE, 2, 3
    InitScriptFrameTableEnd
    InitScriptEnd
