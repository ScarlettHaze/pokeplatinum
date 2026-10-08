#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T07R0207_map_scripts_2
    InitScriptEntryEnd
scr_seq_T07R0207_map_scripts_2:
    InitScriptGoToIfEqual VAR_ROUTE_217_STATE, 0, 1
    InitScriptFrameTableEnd
    InitScriptEnd
