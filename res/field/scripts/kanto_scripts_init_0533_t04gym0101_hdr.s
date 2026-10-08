#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T04GYM0101_map_scripts_2
    InitScriptEntry_OnLoad 7
    InitScriptEntry_OnTransition 8
    InitScriptEntryEnd
scr_seq_T04GYM0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_ROUTE_227_WAKE_RIVAL_STATE, 1, 5
    InitScriptFrameTableEnd
    InitScriptEnd
