#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable scr_seq_T11R0603_map_scripts_2
    InitScriptEntryEnd
scr_seq_T11R0603_map_scripts_2:
    InitScriptGoToIfEqual VAR_RANDOM_SURVIVAL_AREA_RIVAL_MESSAGE, 1, 1
    InitScriptFrameTableEnd
    InitScriptEnd
