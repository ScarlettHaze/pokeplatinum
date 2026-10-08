#include "macros/scrcmd.inc"


    InitScriptEntry_OnResume 1
    InitScriptEntry_OnLoad 3
    InitScriptEntry_OnFrameTable scr_seq_D45R0102_map_scripts_2
    InitScriptEntryEnd
scr_seq_D45R0102_map_scripts_2:
    InitScriptGoToIfEqual VAR_ROUTE_203_RIVAL_STATE, 2, 2
    InitScriptFrameTableEnd
    InitScriptEnd
