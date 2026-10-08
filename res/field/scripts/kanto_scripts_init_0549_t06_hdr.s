#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 10
    InitScriptEntry_OnFrameTable scr_seq_T06_map_scripts_2
    InitScriptEntryEnd
scr_seq_T06_map_scripts_2:
    InitScriptGoToIfEqual VAR_RIVAL_HOUSE_STATE, 1, 14
    InitScriptFrameTableEnd
    InitScriptEnd
