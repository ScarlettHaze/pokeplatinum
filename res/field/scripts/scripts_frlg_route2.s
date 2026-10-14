#include "macros/scrcmd.inc"
#include "res/text/bank/frlg_route2.h"
#include "res/field/events/kanto_events_007_r02.h"

// FRLG's Route 2 (its south half, up to Viridian Forest) on HGSS's: the
// items, Cut trees and the route sign. HGSS has no Diglett's Cave sign here.


    ScriptEntry Route2_RouteSign
    ScriptEntryEnd

Route2_RouteSign:
    DrawSignpostInstantMessage Route2_Text_RouteSign, SIGNPOST_TYPE_ARROW, 5
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
