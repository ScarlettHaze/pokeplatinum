#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_mart.h"
#include "res/field/events/kanto_events_427_t03fs0101.h"

// FRLG's Pewter City Mart on HGSS's (Platinum's standard stock).


    ScriptEntry PewterCity_Mart_Clerk
    ScriptEntry PewterCity_Mart_Youngster
    ScriptEntry PewterCity_Mart_Boy
    ScriptEntryEnd

PewterCity_Mart_Clerk:
    PokeMartCommonWithGreeting
    End

PewterCity_Mart_Youngster:
    NPCMessage PewterCity_Mart_Text_BoughtWeirdFishFromShadyGuy
    End

PewterCity_Mart_Boy:
    NPCMessage PewterCity_Mart_Text_GoodThingsIfRaiseMonsDiligently
    End
