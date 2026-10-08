#include "location.h"

#include "generated/map_headers.h"

#include "field_overworld_state.h"
#include "savedata.h"

static const Location sPlayerStartLocation = {
    .mapHeaderID = MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_2F,
    .warpId = WARP_ID_NONE,
    .x = 6,
    .z = 7,
    .faceDirection = FACE_DOWN,
};

static const Location sPlayerFirstRespawnLocation = {
    .mapHeaderID = MAP_HEADER_KANTO_PALLET,
    .warpId = WARP_ID_NONE,
    .x = 361,
    .z = 364,
    .faceDirection = FACE_DOWN,
};

void SetPlayerStartLocation(Location *outLocation)
{
    *outLocation = sPlayerStartLocation;
}

void SetPlayerFirstRespawnLocation(Location *outLocation)
{
    *outLocation = sPlayerFirstRespawnLocation;
}

void InitPlayerStartLocation(SaveData *saveData)
{
    SetPlayerStartLocation(FieldOverworldState_GetPlayerLocation(SaveData_GetFieldOverworldState(saveData)));
}
