#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 9
    InitScriptEntry_OnFrameTable scr_seq_T02_map_scripts_2
    InitScriptEntryEnd
scr_seq_T02_map_scripts_2:
    InitScriptGoToIfEqual VAR_MT_CORONET_1F_SOUTH_STATE, 1, 12
    InitScriptFrameTableEnd
    InitScriptEnd
