#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 11
    InitScriptEntry_OnFrameTable scr_seq_T01R0301_map_scripts_2
    InitScriptEntryEnd
scr_seq_T01R0301_map_scripts_2:
    InitScriptGoToIfEqual VAR_SPEAR_PILLAR_STATE, 1, 7
    InitScriptFrameTableEnd
    InitScriptEnd
