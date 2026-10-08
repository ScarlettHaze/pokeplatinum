#include "macros/scrcmd.inc"


    InitScriptEntry_OnResume 3
    InitScriptEntry_OnTransition 4
    InitScriptEntry_OnFrameTable scr_seq_P01R0104_map_scripts_2
    InitScriptEntryEnd
scr_seq_P01R0104_map_scripts_2:
    InitScriptGoToIfEqual VAR_VALLEY_WINDWORKS_STATE, 1, 2
    InitScriptFrameTableEnd
    InitScriptEnd
