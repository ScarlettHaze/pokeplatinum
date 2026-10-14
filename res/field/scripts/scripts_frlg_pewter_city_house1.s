#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_pewter_city_house1.h"
#include "res/field/events/kanto_events_425_t03r0201.h"

// FRLG's Pewter City House1 (the Nidoran's) on HGSS's northeast house.


    ScriptEntry PewterCity_House1_Nidoran
    ScriptEntry PewterCity_House1_LittleBoy
    ScriptEntry PewterCity_House1_BaldingMan
    ScriptEntryEnd

PewterCity_House1_Nidoran:
    PokemonCryAndMessage SPECIES_NIDORAN_M, PewterCity_House1_Text_Nidoran
    End

PewterCity_House1_LittleBoy:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message PewterCity_House1_Text_NidoranSit
    WaitButton
    PlayCry SPECIES_NIDORAN_M
    Message PewterCity_House1_Text_Nidoran
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End

PewterCity_House1_BaldingMan:
    NPCMessage PewterCity_House1_Text_TradeMonsAreFinicky
    End
