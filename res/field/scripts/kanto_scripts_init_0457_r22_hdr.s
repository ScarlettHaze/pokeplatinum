#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 2
    InitScriptEntry_OnResume 5
    InitScriptEntry_OnFrameTable scr_seq_R22_map_scripts_2
    InitScriptEntryEnd
scr_seq_R22_map_scripts_2:
    InitScriptGoToIfEqual VAR_ROUTE_203_RIVAL_STATE, 1, 4
    InitScriptFrameTableEnd
    InitScriptEnd
