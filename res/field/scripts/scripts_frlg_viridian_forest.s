#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_forest.h"
#include "res/field/events/kanto_events_143_d46r0101.h"

// FRLG's Viridian Forest on HGSS's. The Bug Catchers are trainers, whose
// lines are in their trainer data. HGSS's forest has no signs, so FRLG's
// Trainer Tips are left out.


    ScriptEntry ViridianForest_Youngster
    ScriptEntry ViridianForest_Boy
    ScriptEntryEnd

ViridianForest_Youngster:
    NPCMessage ViridianForest_Text_FriendsItchingToBattle
    End

ViridianForest_Boy:
    NPCMessage ViridianForest_Text_RanOutOfPokeBalls
    End
