#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_viridian_city_pokemon_center_1f.h"
#include "res/field/events/kanto_events_453_t02pc0101.h"

// FRLG's Viridian City Pokémon Center on HGSS's.


    ScriptEntry ViridianCity_PokemonCenter_1F_Nurse
    ScriptEntry ViridianCity_PokemonCenter_1F_Gentleman
    ScriptEntry ViridianCity_PokemonCenter_1F_Boy
    ScriptEntry ViridianCity_PokemonCenter_1F_Youngster
    ScriptEntryEnd

ViridianCity_PokemonCenter_1F_Nurse:
    Common_CallPokecenterNurse LOCALID_NURSE
    End

ViridianCity_PokemonCenter_1F_Gentleman:
    NPCMessage ViridianCity_PokemonCenter_1F_Text_FeelFreeToUsePC
    End

ViridianCity_PokemonCenter_1F_Boy:
    NPCMessage ViridianCity_PokemonCenter_1F_Text_PokeCenterInEveryTown
    End

ViridianCity_PokemonCenter_1F_Youngster:
    NPCMessage ViridianCity_PokemonCenter_1F_Text_PokeCentersHealMons
    End
