#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_pokemon_center_1f.h"
#include "res/field/events/kanto_events_428_t03pc0101.h"

// FRLG's Pewter City Pokémon Center on HGSS's. FRLG's Jigglypuff sings its
// song; here it only cries.


    ScriptEntry PewterCity_PokemonCenter_1F_Nurse
    ScriptEntry PewterCity_PokemonCenter_1F_Gentleman
    ScriptEntry PewterCity_PokemonCenter_1F_Jigglypuff
    ScriptEntry PewterCity_PokemonCenter_1F_Youngster
    ScriptEntry PewterCity_PokemonCenter_1F_Kid1
    ScriptEntry PewterCity_PokemonCenter_1F_Kid2
    ScriptEntryEnd

PewterCity_PokemonCenter_1F_Nurse:
    Common_CallPokecenterNurse LOCALID_NURSE
    End

PewterCity_PokemonCenter_1F_Gentleman:
    NPCMessage PewterCity_PokemonCenter_1F_Text_TeamRocketMtMoonImOnPhone
    End

PewterCity_PokemonCenter_1F_Jigglypuff:
    PokemonCryAndMessage SPECIES_JIGGLYPUFF, PewterCity_PokemonCenter_1F_Text_Jigglypuff
    End

PewterCity_PokemonCenter_1F_Youngster:
    NPCMessage PewterCity_PokemonCenter_1F_Text_WhenJiggylypuffSingsMonsGetDrowsy
    End

PewterCity_PokemonCenter_1F_Kid1:
    NPCMessage PewterCity_PokemonCenter_1F_Text_TradingMyClefairyForPikachu
    End

PewterCity_PokemonCenter_1F_Kid2:
    NPCMessage PewterCity_PokemonCenter_1F_Text_TradingPikachuWithKid
    End
