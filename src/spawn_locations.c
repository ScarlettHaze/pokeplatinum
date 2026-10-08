#include "spawn_locations.h"

#include <nitro.h>
#include <string.h>

#include "generated/first_arrival_to_zones.h"
#include "generated/map_headers.h"

#include "field/field_system.h"

#include "inlines.h"
#include "location.h"
#include "system_flags.h"
#include "vars_flags.h"

typedef struct SpawnLocation {
    u16 blackOutMapHeaderID;
    u16 blackOutX;
    u16 blackOutZ;
    u16 flyMapHeaderID;
    u16 flyX;
    u16 flyZ;
    u8 isWarpPos;
    u8 unlockOnMapEntry;
    u16 firstArrival;
} SpawnLocation;

// Kanto (from HGSS) replaces Sinnoh. The table keeps its 20 entries since spawn IDs
// and first arrival flags are referenced by index; unused ones point at Pallet Town.
static const SpawnLocation sSpawnLocations[] = {
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x1, FIRST_ARRIVAL_TWINLEAF_TOWN },
    { MAP_HEADER_KANTO_VIRIDIAN_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_VIRIDIAN, 0x168, 0x107, 0x1, 0x1, FIRST_ARRIVAL_SANDGEM_TOWN },
    { MAP_HEADER_KANTO_PEWTER_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_PEWTER, 0x178, 0x6b, 0x1, 0x1, FIRST_ARRIVAL_FLOAROMA_TOWN },
    { MAP_HEADER_KANTO_CERULEAN_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_CERULEAN, 0x27d, 0x84, 0x1, 0x1, FIRST_ARRIVAL_SOLACEON_TOWN },
    { MAP_HEADER_KANTO_LAVENDER_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_LAVENDER, 0x2ea, 0xeb, 0x1, 0x1, FIRST_ARRIVAL_CELESTIC_TOWN },
    { MAP_HEADER_KANTO_VERMILION_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_VERMILION, 0x271, 0x127, 0x1, 0x1, FIRST_ARRIVAL_JUBILIFE_CITY },
    { MAP_HEADER_KANTO_CELADON_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_CELADON, 0x22f, 0xee, 0x1, 0x1, FIRST_ARRIVAL_CANALAVE_CITY },
    { MAP_HEADER_KANTO_FUCHSIA_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_FUCHSIA, 0x219, 0x1b8, 0x1, 0x1, FIRST_ARRIVAL_OREBURGH_CITY },
    { MAP_HEADER_KANTO_CINNABAR_ISLAND_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_CINNABAR_ISLAND, 0x16f, 0x1f7, 0x1, 0x1, FIRST_ARRIVAL_ETERNA_CITY },
    { MAP_HEADER_KANTO_POKEMON_LEAGUE_ENTRANCE, 0x6, 0x15, MAP_HEADER_KANTO_INDIGO_PLATEAU, 0xf0, 0xc9, 0x1, 0x1, FIRST_ARRIVAL_HEARTHOME_CITY },
    { MAP_HEADER_KANTO_SAFFRON_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_SAFFRON, 0x26e, 0xf3, 0x1, 0x1, FIRST_ARRIVAL_PASTORIA_CITY },
    { MAP_HEADER_KANTO_ROUTE_3_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_ROUTE_3, 0x1ef, 0x6b, 0x1, 0x1, FIRST_ARRIVAL_VEILSTONE_CITY },
    { MAP_HEADER_KANTO_ROUTE_10_POKECENTER_1F, 0x8, 0xd, MAP_HEADER_KANTO_ROUTE_10, 0x2f2, 0xa4, 0x1, 0x1, FIRST_ARRIVAL_SUNYSHORE_CITY },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_SNOWPOINT_CITY },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_FIGHT_AREA },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_SURVIVAL_AREA },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_RESORT_AREA },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_ROUTE_221 },
    { MAP_HEADER_KANTO_PALLET_TOWN_REDS_HOUSE_1F, 0x6, 0x8, MAP_HEADER_KANTO_PALLET, 0x169, 0x16c, 0x1, 0x0, FIRST_ARRIVAL_POKEMON_LEAGUE },
};

static int MapSpawnIdToIndex(int spawnDestination)
{
    if ((spawnDestination <= 0) || (spawnDestination > NELEMS(sSpawnLocations))) {
        GF_ASSERT(FALSE);
        spawnDestination = 1;
    }

    spawnDestination--;
    return spawnDestination;
}

int FieldOverworldState_GetDefaultWarpID(void)
{
    return 1;
}

void Location_InitFly(int flyDestination, Location *location)
{
    flyDestination = MapSpawnIdToIndex(flyDestination);

    location->mapHeaderID = sSpawnLocations[flyDestination].flyMapHeaderID;
    location->warpId = WARP_ID_NONE;
    location->x = sSpawnLocations[flyDestination].flyX;
    location->z = sSpawnLocations[flyDestination].flyZ;
    location->faceDirection = FACE_DOWN;
}

void Location_InitBlackOut(int blackOutDestination, Location *location)
{
    blackOutDestination = MapSpawnIdToIndex(blackOutDestination);

    location->mapHeaderID = sSpawnLocations[blackOutDestination].blackOutMapHeaderID;
    location->warpId = WARP_ID_NONE;
    location->x = sSpawnLocations[blackOutDestination].blackOutX;
    location->z = sSpawnLocations[blackOutDestination].blackOutZ;
    location->faceDirection = FACE_UP;
}

int GetMapBlackOutWarpId(enum MapHeaderID mapHeaderID)
{
    for (int i = 0; i < NELEMS(sSpawnLocations); i++) {
        if (sSpawnLocations[i].blackOutMapHeaderID == mapHeaderID && sSpawnLocations[i].isWarpPos) {
            return i + 1;
        }
    }

    return 0;
}

int GetMapFlyWarpId(enum MapHeaderID mapHeaderID)
{
    for (int i = 0; i < NELEMS(sSpawnLocations); i++) {
        if (sSpawnLocations[i].flyMapHeaderID == mapHeaderID && sSpawnLocations[i].isWarpPos) {
            return i + 1;
        }
    }

    return 0;
}

int GetSpawnIdByMapAndCoords(enum MapHeaderID mapHeaderID, int param1, int param2)
{
    int i;
    int v1 = param1 / 32;
    int v2 = param2 / 32;
    int destinationId = 0;

    for (i = 0; i < NELEMS(sSpawnLocations); i++) {
        if (sSpawnLocations[i].flyMapHeaderID == mapHeaderID) {
            destinationId = i + 1;

            if ((v1 == sSpawnLocations[i].flyX / 32) && (v2 == sSpawnLocations[i].flyZ / 32)) {
                return destinationId;
            }
        }
    }

    return destinationId;
}

void TryUnlockFlyLocationByMap(FieldSystem *fieldSystem, enum MapHeaderID mapHeaderID)
{
    for (int v0 = 0; v0 < NELEMS(sSpawnLocations); v0++) {
        if ((sSpawnLocations[v0].flyMapHeaderID == mapHeaderID) && sSpawnLocations[v0].unlockOnMapEntry) {
            SystemFlag_HandleFirstArrivalToZone(SaveData_GetVarsFlags(fieldSystem->saveData), HANDLE_FLAG_SET, sSpawnLocations[v0].firstArrival);
            return;
        }
    }
}

BOOL CheckFlyLocationUnlocked(FieldSystem *fieldSystem, int flyLocation)
{
    int flyDestination = MapSpawnIdToIndex(flyLocation);
    return SystemFlag_HandleFirstArrivalToZone(SaveData_GetVarsFlags(fieldSystem->saveData), HANDLE_FLAG_CHECK, sSpawnLocations[flyDestination].firstArrival);
}
