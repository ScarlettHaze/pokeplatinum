#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T02R0302_map_scripts_2
    InitScriptEntryEnd
scr_seq_T02R0302_map_scripts_2:
    InitScriptGoToIfEqual VAR_SNOWPOINT_CITY_STATE, 0, 3
    InitScriptGoToIfEqual VAR_SNOWPOINT_CITY_STATE, 5, 4
    InitScriptFrameTableEnd
    InitScriptEnd
