#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_D43R0102_map_scripts_2
    InitScriptEntry_OnResume 2
    InitScriptEntryEnd
scr_seq_D43R0102_map_scripts_2:
    InitScriptGoToIfEqual VAR_ROUTE_224_STATE, 1, 1
    InitScriptFrameTableEnd
    InitScriptEnd
