#ifndef POKEPLATINUM_OV5_AREA_DATA_H
#define POKEPLATINUM_OV5_AREA_DATA_H

#include <nnsys.h>

#include "overlay005/map_prop_animation.h"
#include "overlay005/map_prop_material_shape.h"

#define MAX_MAP_PROP_MODEL_FILES 1024

typedef struct AreaDataManagerLoadData {
    int areaDataArchiveID;
    MapPropAnimationManager *mapPropAnimMan;
    u16 mapPropModelIDsCount;
    int dummy0C;
} AreaDataManagerLoadData;

#define GROUND_ANIMATION_NONE 0

typedef struct AreaDataFile {
    u16 mapPropArchivesID;
    u16 mapTextureArchiveID;
    // Unused in Sinnoh's areas. Kanto's areas (from HGSS) store their ground
    // animation here, as its bm_anime archive ID + 1 or GROUND_ANIMATION_NONE.
    u16 groundAnimation;
    u16 areaLightArchiveID;
} AreaDataFile;

typedef struct AreaDataManager {
    int dummy00;
    NNSG3dResFileHeader *mapPropModelFiles[MAX_MAP_PROP_MODEL_FILES];
    void *mapTextureFile;
    void *mapPropTextureFile;
    NNSG3dResTex *mapTexture;
    NNSG3dResTex *mapPropTexture;
    MapPropMaterialShape *mapPropMatShp;
    AreaDataFile areaData;
    AreaDataManagerLoadData *loadData;
    // Note: the first element is the size of this array
    u16 *mapPropModelIDs;
    void *groundAnimationFile;
    NNSG3dAnmObj *groundAnimationObj;
} AreaDataManager;

AreaDataManager *AreaDataManager_Alloc(int areaDataArchiveID, MapPropAnimationManager *mapPropAnimMan);
void AreaDataManager_Load(AreaDataManager *areaDataManager);
NNSG3dResFileHeader **AreaDataManager_GetMapPropModelFile(const int mapPropModelID, AreaDataManager *const areaDataManager);
void AreaDataManager_Free(AreaDataManager **areaDataManager);
NNSG3dResTex *AreaDataManager_GetMapTexture(const AreaDataManager *areaDataManager);
NNSG3dResTex *AreaDataManager_GetMapPropTexture(const AreaDataManager *areaDataManager);
const MapPropMaterialShape *AreaDataManager_GetMapPropMaterialShape(const AreaDataManager *areaDataManager);
BOOL AreaDataManager_IsOutdoorsLighting(const AreaDataManager *areaDataManager);
u8 AreaDataManager_GetAreaLightArchiveID(const AreaDataManager *areaDataManager);
int AreaDataManager_GetMapPropModelID(const AreaDataManager *areaDataManager, const int index);
BOOL AreaDataManager_HasMapPropModelFile(const AreaDataManager *areaDataManager, const int mapPropModelID);
void AreaDataManager_AdvanceGroundAnimation(AreaDataManager *areaDataManager);
void AreaDataManager_AddGroundAnimationToRenderObj(const AreaDataManager *areaDataManager, NNSG3dRenderObj *mapRenderObj, const int landDataID);

#endif // POKEPLATINUM_OV5_AREA_DATA_H
