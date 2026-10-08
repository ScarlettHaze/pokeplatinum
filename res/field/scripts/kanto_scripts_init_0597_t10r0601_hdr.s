#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T10R0601_map_scripts_2
    InitScriptEntry_OnTransition 3
    InitScriptEntryEnd
scr_seq_T10R0601_map_scripts_2:
    InitScriptGoToIfEqual VAR_UNUSED_0x40AF, 0, 2
    InitScriptFrameTableEnd
    InitScriptEnd
