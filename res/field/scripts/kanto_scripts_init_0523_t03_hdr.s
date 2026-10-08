#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 9
    InitScriptEntry_OnLoad 14
    InitScriptEntry_OnResume 12
    InitScriptEntry_OnFrameTable scr_seq_T03_map_scripts_2
    InitScriptEntryEnd
scr_seq_T03_map_scripts_2:
    InitScriptGoToIfEqual VAR_PASTORIA_CITY_STATE, 2, 13
    InitScriptFrameTableEnd
    InitScriptEnd
