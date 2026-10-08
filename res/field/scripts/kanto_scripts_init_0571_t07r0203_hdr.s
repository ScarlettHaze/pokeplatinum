#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 9
    InitScriptEntry_OnResume 12
    InitScriptEntry_OnFrameTable scr_seq_T07R0203_map_scripts_2
    InitScriptEntryEnd
scr_seq_T07R0203_map_scripts_2:
    InitScriptGoToIfEqual VAR_MT_CORONET_2F_STATE, 0, 11
    InitScriptFrameTableEnd
    InitScriptEnd
