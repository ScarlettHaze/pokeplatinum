#include "macros/scrcmd.inc"


    InitScriptEntry_OnTransition 1
    InitScriptEntry_OnFrameTable InitScriptFrameTable
    InitScriptEntryEnd

InitScriptFrameTable:
    InitScriptGoToIfEqual VAR_MAP_SCENE_PALLET_TOWN_PROFESSOR_OAKS_LAB, 1, 2
    InitScriptFrameTableEnd

    InitScriptEnd
