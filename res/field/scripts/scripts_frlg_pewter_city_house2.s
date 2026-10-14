#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_house2.h"
#include "res/field/events/kanto_events_430_t03r0601.h"

// FRLG's Pewter City House2 on HGSS's southwest house.


    ScriptEntry PewterCity_House2_OldMan
    ScriptEntry PewterCity_House2_LittleBoy
    ScriptEntryEnd

PewterCity_House2_OldMan:
    NPCMessage PewterCity_House2_Text_MonsLearnTechniquesAsTheyGrow
    End

PewterCity_House2_LittleBoy:
    NPCMessage PewterCity_House2_Text_MonsEasierCatchIfStatused
    End
