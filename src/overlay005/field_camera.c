#include "overlay005/field_camera.h"

#include <nitro.h>

#include "field/field_system.h"

#include "camera.h"
#include "math_util.h"

// History size must be greater than the delay, so we add 1 to the delay to get the minimum acceptable size.
#define FIELD_CAMERA_DELAY        6
#define FIELD_CAMERA_HISTORY_SIZE (FIELD_CAMERA_DELAY + 1)

typedef struct {
    fx32 distance;
    CameraAngle cameraAngle;
    u8 projection;
    u16 verticalFov;
    fx32 nearPlaneDist;
    fx32 farPlaneDist;
    VecFx32 offset;
} CameraSettings;

static const CameraSettings sCameraTypes[] = {
    [CAMERA_TYPE_DEFAULT] = {
        .distance = FX32_CONST(666.922119140625),
        .cameraAngle = { -F32_DEG_TO_IDX(59.051513671875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.0914306640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_PASTORIA_GYM] = {
        .distance = FX32_CONST(666.922119140625),
        .cameraAngle = { -F32_DEG_TO_IDX(68.367919921875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.0914306640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_ZOOMED_IN] = {
        .distance = FX32_CONST(515.4560546875),
        .cameraAngle = { -F32_DEG_TO_IDX(54.656982421875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(10.458984375),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_CANALAVE_GYM] = {
        .distance = FX32_CONST(666.922119140625),
        .cameraAngle = { -F32_DEG_TO_IDX(59.051513671875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.0914306640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_INTERIOR_ORTHOGRAPHIC] = {
        .distance = FX32_CONST(1563.537841796875),
        .cameraAngle = { -F32_DEG_TO_IDX(50.086669921875), 0, 0 },
        .projection = CAMERA_PROJECTION_ORTHOGRAPHIC,
        .verticalFov = F32_DEG_TO_IDX(3.5211181640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = FX32_ONE * 1735,
    },
    [CAMERA_TYPE_SPEAR_PILLAR] = {
        .distance = FX32_CONST(316.501220703125),
        .cameraAngle = { -F32_DEG_TO_IDX(59.0460205078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(16.8804931640625),
        .nearPlaneDist = FX32_ONE * 10,
        .farPlaneDist = FX32_ONE * 1008,
    },
    [CAMERA_TYPE_MT_CORONET_EXT_SOUTH] = {
        .distance = FX32_CONST(866.554443359375),
        .cameraAngle = { -F32_DEG_TO_IDX(73.1085205078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(6.3336181640625),
        .nearPlaneDist = FX32_ONE * 115,
        .farPlaneDist = FX32_ONE * 1221,
    },
    [CAMERA_TYPE_MT_CORONET_EXT_NORTH] = {
        .distance = FX32_CONST(666.922119140625),
        .cameraAngle = { -F32_DEG_TO_IDX(59.0460205078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.0914306640625),
        .nearPlaneDist = FX32_ONE * 153,
        .farPlaneDist = FX32_ONE * 1031,
    },
    [CAMERA_TYPE_STARK_MOUNTAIN_ROOM_2] = {
        .distance = FX32_CONST(662.922119140625),
        .cameraAngle = { -F32_DEG_TO_IDX(70.4718017578125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(9.8492431640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = FX32_ONE * 1034,
    },
    [CAMERA_TYPE_OREBURGH_GYM] = {
        .distance = FX32_CONST(357.6044921875),
        .cameraAngle = { -F32_DEG_TO_IDX(40.5889892578125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(15.029296875),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_VEILSTONE_GYM] = {
        .distance = FX32_CONST(1202.355712890625),
        .cameraAngle = { -F32_DEG_TO_IDX(60.8038330078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(4.5758056640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = FX32_ONE * 1746,
    },
    [CAMERA_TYPE_SLIGHTLY_ZOOMED_OUT] = {
        .distance = FX32_CONST(675.833251953125),
        .cameraAngle = { -F32_DEG_TO_IDX(57.8155517578125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.0914306640625),
        .nearPlaneDist = FX32_ONE * 230,
        .farPlaneDist = FX32_ONE * 1127,
    },
    [CAMERA_TYPE_CAVE] = {
        .distance = FX32_CONST(574.577880859375),
        .cameraAngle = { -F32_DEG_TO_IDX(63.2647705078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(9.4976806640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_IRON_ISLAND_CAVE] = {
        .distance = FX32_CONST(515.4560546875),
        .cameraAngle = { -F32_DEG_TO_IDX(47.7960205078125), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(10.458984375),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_HALL_OF_ORIGIN] = {
        .distance = FX32_CONST(169.462158203125),
        .cameraAngle = { -F32_DEG_TO_IDX(78.37646484375), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(29.5367431640625),
        .nearPlaneDist = FX32_ONE * 10,
        .farPlaneDist = FX32_ONE * 1008,
    },
    [CAMERA_TYPE_LAKE_ACUITY] = {
        .distance = FX32_CONST(653.929443359375),
        .cameraAngle = { -F32_DEG_TO_IDX(54.656982421875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(8.349609375),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    [CAMERA_TYPE_UNUSED_16] = {
        .distance = FX32_CONST(330.921875),
        .cameraAngle = { -F32_DEG_TO_IDX(59.051513671875), 0, 0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = F32_DEG_TO_IDX(15.4742431640625),
        .nearPlaneDist = CAMERA_DEFAULT_NEAR_CLIP,
        .farPlaneDist = CAMERA_DEFAULT_FAR_CLIP,
    },
    // Camera types from HGSS, used by the maps imported from Kanto.
    [CAMERA_TYPE_HGSS_00] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xdd62, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
    },
    [CAMERA_TYPE_HGSS_01] = {
        .distance = 0x19465c,
        .cameraAngle = { 0xe383, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x981,
        .nearPlaneDist = 0x86000,
        .farPlaneDist = 0x4b0000,
        .offset = { 0x0, 0x25000, -0xf000 },
    },
    [CAMERA_TYPE_HGSS_02] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xe3c2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
    },
    [CAMERA_TYPE_HGSS_03] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xf242, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
        .offset = { 0x0, 0x1e9c5, -0xc0c9 },
    },
    [CAMERA_TYPE_HGSS_04] = {
        .distance = 0x61b89b,
        .cameraAngle = { 0xdc82, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_ORTHOGRAPHIC,
        .verticalFov = 0x281,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x6c7000,
    },
    [CAMERA_TYPE_HGSS_05] = {
        .distance = 0x1d19f6,
        .cameraAngle = { 0xdda2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x881,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x488000,
        .offset = { 0x0, 0x0, -0x18000 },
    },
    [CAMERA_TYPE_HGSS_06] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xdfe2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x5dc000,
    },
    [CAMERA_TYPE_HGSS_07] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xe1e2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
        .offset = { 0x0, 0x17c5b, -0x16a1e },
    },
    [CAMERA_TYPE_HGSS_08] = {
        .distance = 0x20374c,
        .cameraAngle = { 0xd922, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x770,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x384000,
    },
    [CAMERA_TYPE_HGSS_09] = {
        .distance = 0x29bec1,
        .cameraAngle = { 0xd582, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
    },
    [CAMERA_TYPE_HGSS_10] = {
        .distance = 0x13c805,
        .cameraAngle = { 0xdf42, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0xc81,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x6a4000,
        .offset = { 0x0, 0xc5f1, -0x25c74 },
    },
    [CAMERA_TYPE_HGSS_11] = {
        .distance = 0x215c29,
        .cameraAngle = { 0xe3c2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x741,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
        .offset = { 0x0, -0x8000, 0x0 },
    },
    [CAMERA_TYPE_HGSS_12] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xdfe2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x6a4000,
        .offset = { 0x0, 0x0, -0x20000 },
    },
    [CAMERA_TYPE_HGSS_13] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xf242, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x6a4000,
        .offset = { 0x0, 0x1e9c5, -0x1e0c9 },
    },
    [CAMERA_TYPE_HGSS_14] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xd4c2, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x4b0000,
    },
    [CAMERA_TYPE_HGSS_15] = {
        .distance = 0x61b89b,
        .cameraAngle = { 0xdc82, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_ORTHOGRAPHIC,
        .verticalFov = 0x281,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x6c7000,
        .offset = { 0x0, 0x0, -0x2e000 },
    },
    [CAMERA_TYPE_HGSS_16] = {
        .distance = 0x29aec1,
        .cameraAngle = { 0xd602, 0x0, 0x0 },
        .projection = CAMERA_PROJECTION_PERSPECTIVE,
        .verticalFov = 0x5c1,
        .nearPlaneDist = 0x96000,
        .farPlaneDist = 0x384000,
    },
};

void FieldCamera_Create(const VecFx32 *_target, FieldSystem *fieldSystem, const enum CameraType configID, const BOOL withHistory)
{
    const VecFx32 *target = _target;
    const CameraSettings *config = &sCameraTypes[configID];

    GF_ASSERT(configID < NELEMS(sCameraTypes));

    fieldSystem->camera = Camera_Alloc(HEAP_ID_FIELD1);

    Camera_InitWithTarget(target, config->distance, &config->cameraAngle, config->verticalFov, config->projection, TRUE, fieldSystem->camera);
    Camera_SetAsActive(fieldSystem->camera);
    Camera_SetClipping(config->nearPlaneDist, config->farPlaneDist, fieldSystem->camera);
    Camera_Move(&config->offset, fieldSystem->camera);

    if (withHistory) {
        Camera_InitHistory(FIELD_CAMERA_HISTORY_SIZE, FIELD_CAMERA_DELAY, CAMERA_DELAY_Y, HEAP_ID_FIELD1, fieldSystem->camera);
    }
}

void FieldCamera_Delete(FieldSystem *fieldSystem)
{
    Camera_ClearActive();
    Camera_DeleteHistory(fieldSystem->camera);
    Camera_Delete(fieldSystem->camera);
}
