#ifndef POKEPLATINUM_DATA_FIELD_HIDDEN_ITEMS_H
#define POKEPLATINUM_DATA_FIELD_HIDDEN_ITEMS_H

#include "constants/items.h"
#include "generated/vars_flags.h"

typedef struct HiddenItem {
    u16 item; //< Item given on pickup
    u8 qty; //< Quantity of the item given on pickup
    u8 range; //< Search range of the item
    u16 pad; //< Padding; unused
    u16 script; //< Index of the script to invoke on pickup
} HiddenItem;

#define HIDDEN_ITEM_ENTRY(item_in, qty_in, range_in, script_in)                                                    \
    {                                                                                                              \
        .item = item_in, .qty = qty_in, .range = range_in, .pad = 0, .script = script_in - HIDDEN_ITEM_FLAGS_START \
    }

// clang-format off
const HiddenItem gHiddenItems[] = {
    // Kanto replaces Sinnoh: its hidden items (from HGSS) take the hidden item
    // flags from the start.
#include "data/field/kanto_hidden_items.h"
};
// clang-format on

#endif
