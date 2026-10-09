# Kanto from HGSS

These scripts replace Sinnoh with HGSS's Kanto in Platinum. Each script reads a
[pokeheartgold](https://github.com/pret/pokeheartgold) checkout and writes
into this repository. Re-running a script is safe: it strips its previous
output first.

Run them in this order, each with the pokeheartgold path as the argument:

1. `import_kanto.py`: land data, textures, buildings, building animations,
   ground animations and area data.
2. `import_kanto_world.py`: the world matrix, the other matrices, map
   headers, warps and location names.
3. `import_kanto_encounters.py`: wild encounters.
4. `import_kanto_intro.py`: Professor Oak's intro.
5. `import_kanto_town_map.py`: the Town Map. It saves the map as
   `kanto_town_map.png`; `import_kanto_town_map.py --png <file>` rebuilds the
   Town Map from an edited copy.
6. `import_kanto_sprites.py`: overworld sprites for the player and NPCs.
7. `import_kanto_music.py`: the map headers' music, by HGSS's song names.
8. `import_kanto_scripts.py`: text, signs, NPCs, items, marts and scripts.
   It reads sound IDs from `build/res/sound/pl_sound_data.naix`, so build
   the ROM once first. **Don't run it for now:** the game is becoming an
   FRLG remake, and HGSS's scripts and events were taken out (see below).
   Running it would put them back.

## Done

- **Overworld:** Kanto replaces Sinnoh in the main map matrix (000), including
  the filler terrain around its edges.
- **Maps:** all 199 Kanto maps have headers, matrices and warps. HGSS's
  location names, camera types and area lighting are used.
- **Animations:**
  - HGSS's ground animations: the sea and ponds animate.
  - Building animations, including the time-of-day ones: windows light up at
    night.
  - Door opening animations.
- **Start, respawn and Fly:** a new game starts in Red's room in Pallet Town.
  Blacking out and Fly use Kanto's towns and Pokémon Centers.
- **Wild encounters:** all 55 Kanto encounter tables are converted to
  Platinum's encounter format.
- **Intro:** Professor Oak, Ethan and Lyra, with Marill and HGSS's wording.
- **Town Map:** Kanto's map comes from HGSS's Pokégear map, on both the top
  screen and the zoomed-in bottom screen. The fly points are Kanto's towns.
  Both screens come from one picture, `kanto_town_map.png`: 256×256 at 8
  pixels per block. The top screen shows its top 192 rows. Each 8×8 tile may
  use 15 colors, and the whole picture 45.
- **Sprites:**
  - The player is Ethan or Lyra in every state.
  - 120 NPC and Pokémon sprites are imported as `OBJ_EVENT_GFX_KANTO_*`.
    `kanto_sprites.json` records the mapping from HGSS's sprite IDs.
  - Snorlax, the Pokémon League door and the stop sign are 64×64 still
    objects, set up like Platinum's Regigigas. Apricorn trees are still
    objects too, showing the bare tree: HGSS's apricorns and the tree's shake
    come from its apricorn save data and scripts, which are part of the
    scripts job below.
- **Text and signs** (from `import_kanto_scripts.py`):
  - Every Kanto message bank is a Platinum text bank
    (`res/text/kanto_*.json`), and the Kanto map headers use them. The
    message IDs stay HGSS's.
  - Signs use HGSS's signpost graphics (`kanto_signs.py`), so map and arrow
    signs show HGSS's pictures.
  - Kanto's specialty marts are in Platinum's mart table
    (`include/data/kanto_marts.h`).
  - The healing animation uses HGSS's healing machine, Poké Balls and screen
    (`healing_machine_animation/pokecenter.c`).
- **Scripts and events: taken out.** HGSS's translated scripts, NPCs, sign
  events, item balls, hidden items and step triggers were imported, then
  removed so the maps can get FRLG's instead. The maps keep only their
  warps, and the hidden items table is Sinnoh's again.
  `import_kanto_scripts.py`, `kanto_scripts.py` and the report stay for
  reference.

## Left to do

Smallest first.

### 1. Music

Done:

- **The sound archive is HGSS's,** unchanged: its music, sound effects,
  cries and instruments (`res/sound/gs_sound_data.sdat`, from pokeheartgold).
  Platinum's sound sources are gone.
- `hgss_sound.py` builds `pl_sound_data.naix` from it, so Platinum's code
  keeps naming sounds by Platinum's names. Each Platinum name points at an
  HGSS sound: the one chosen in its `HAND` table, else the one with the
  Platinum sound's original DP name (`pl_sound_names.json` records those),
  else the one with the same name. 562 of the 592 sound effects the code uses
  have the same name in HGSS. HGSS's own names are defined too.
- Sounds HGSS lacks map to the closest HGSS sound: Platinum's fanfares to
  HGSS's (level up, item, key item, evolution, badge, TM), the eyes-meet
  music to HGSS's Kanto themes, contests to the Pokéathlon, the Battle
  Frontier and Wi-Fi to HGSS's, and Sinnoh's places to similar HGSS songs.
  The few Sinnoh-only sound effects with nothing close are silent.
- Cries keep their numbers: HGSS's cry wave archives are indexed by species,
  like Platinum's, with Sky Forme Shaymin at 494.
- HGSS's field songs each have their own bank, unlike Sinnoh's, so a field
  song always loads its bank and samples, including on a walk from one map
  to the next.
- `SOUND_SYSTEM_HEAP_SIZE` is HGSS's, 0xBEAE0 (781 KB): 12 KB more than
  Platinum's.
- The Kanto map headers use HGSS's songs by name. Surf, the bicycle and
  battles use HGSS's Kanto music, named in `include/data/kanto_sound.h`:
  Kanto's wild, trainer and gym leader themes, HGSS's gym leader theme for
  the Elite Four, its Champion and rival themes, and its three victory songs.
- A battle song has 87 KB of the sound heap; the largest, Kanto's trainer
  theme, leaves 33 KB. Surf's song leaves 75 KB on the field, enough for
  every sound effect group a menu loads.
- `nitrosfx` aligned the sound archive's files wrongly whenever its headers
  didn't end on a 32 byte boundary, and the game hung loading sounds at boot.
  This is fixed. Archives that were already aligned build the same.

Still to do:

- HGSS's low HP music in battle isn't ported: Platinum has none.
- Untested with HGSS's sound archive: Wi-Fi, the Union Room, the Battle
  Frontier, contests and the Underground.
- FRLG's events will need their own picks from HGSS's songs, such as the
  rival's theme and Team Rocket's.

### 2. FRLG's events, scripts and trainers (the biggest job)

The plan is a FRLG remake on HGSS's Kanto. FRLG's story, trainers, items and
text come from [pokefirered](https://github.com/pret/pokefirered). Places
HGSS's Kanto lacks or changed (Cinnabar, the Pokémon Tower, the Rocket
Hideout, the S.S. Anne, Silph Co.'s floors, the Safari Zone) will reuse
Johto maps from HGSS where they fit. The Sevii Islands are left out for now.

- **The opening:** Oak stopping the player on Route 1, choosing a starter in
  his lab, and the first rival battle. A new game has no Pokémon until then.
- **NPCs, signs, items and hidden items** on every map, with FRLG's text.
- **Trainers:** FRLG's trainers and parties, the gym leaders, the Elite Four
  and the rival. Platinum's trainers are JSON files in `res/trainers/data`.
- **The rival:** Platinum's intro still names Barry and shows his picture.
- **Missing items:** Platinum lacks some FRLG story items, such as the Oak's
  Parcel, the S.S. Ticket, the Silph Scope and the Poké Flute.
- **Apricorn trees:** HGSS's apricorn trees still stand as bare trees, and
  FRLG has none.

### 3. Smaller gaps

- **Disabled warps:** 3 warps lead to Johto maps that weren't imported. They
  are the Pokémon League Wi-Fi room, the S.S. Aqua and the Magnet Train to
  Goldenrod. Each is moved off its map.
- **Encounters:**
  - Platinum's encounter format only varies grass slots 2 and 3 by time of
    day. HGSS varies every slot.
  - Version exclusives use HeartGold's species.
  - Radio (Hoenn/Sinnoh sound), Rock Smash and swarm encounters have no
    Platinum equivalent and aren't imported.
- **Town Map:** the zoom button still shows a Sinnoh outline. Kanto has no
  area or landmark descriptions; HGSS's map has none either. Fly points use 1×1
  markers, not HGSS's box shapes.
- **Pokédex area map:** Kanto's encounters are excluded. The area map is
  drawn for Sinnoh.
- **Sinnoh code:** some Platinum features still assume Sinnoh and are
  unreachable or untested in Kanto. Examples are the Underground, Poké
  Radar, swarms, Pokétch map apps, the Battle Frontier and the Distortion
  World.

## Testing

Only Pallet Town and Route 1 have been played. The test covered warps,
lighting, animations, a wild battle, the Town Map and the sprites. With the
scripts and events taken out, a new game still starts in Red's room and
Pallet Town loads. The other maps build, but nobody has walked them yet.

With HGSS's sound archive: Pallet Town and Route 1 walking and on the
bicycle, Surf on Route 21 with the Bag and start menu open, every battle
song followed by its victory song and the map's song (through the calls a
battle makes), the opening, title screen and Oak's intro, eight common sound
effects, seven fanfares and five cries (Chatot's among them). Every sound
loads and starts.

A wild battle with no Pokémon in the party goes to a black screen; a new
game needs its starter first.

Emulator testing used py-desmume with a temporary, uncommitted patch. The
patch skips the intro, names the player, gives a Pokémon, and registers the
Town Map to Y. It can also move the starting position into a given map.
py-desmume's save chip fails the game's check at boot, so the patch also skips
that check.
