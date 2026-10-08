#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T10R0401_map_scripts_2
    InitScriptEntry_OnLoad 3
    InitScriptEntryEnd
scr_seq_T10R0401_map_scripts_2:
    InitScriptGoToIfEqual VAR_MAP_LOCAL_0x01, 0, 1
    InitScriptFrameTableEnd
    InitScriptEnd
