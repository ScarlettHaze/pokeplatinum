#include "macros/scrcmd.inc"


    InitScriptEntry_OnFrameTable InitScriptFrameTable
    InitScriptEntryEnd

InitScriptFrameTable:
    InitScriptGoToIfEqual VAR_MAP_SCENE_VIRIDIAN_CITY_MART, 0, 1
    InitScriptFrameTableEnd

    InitScriptEnd
