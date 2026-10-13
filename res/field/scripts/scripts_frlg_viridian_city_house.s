#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_city_house.h"
#include "res/field/events/kanto_events_449_t02r0201.h"

// FRLG's Viridian City house (Speary's) on HGSS's northeast house. HGSS's
// house has no sign, so Speary's nickname sign is left out.


    ScriptEntry ViridianCity_House_BaldingMan
    ScriptEntry ViridianCity_House_LittleGirl
    ScriptEntry ViridianCity_House_Speary
    ScriptEntryEnd

ViridianCity_House_BaldingMan:
    NPCMessage ViridianCity_House_Text_NicknamingIsFun
    End

ViridianCity_House_LittleGirl:
    NPCMessage ViridianCity_House_Text_MyDaddyLovesMonsToo
    End

ViridianCity_House_Speary:
    PokemonCryAndMessage SPECIES_SPEAROW, ViridianCity_House_Text_Speary
    End
