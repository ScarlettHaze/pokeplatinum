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
7. `import_kanto_music.py`: map music.
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

- `import_kanto_music.py` extracts the 36 Kanto songs from HGSS's sound
  archive into `res/sound/kanto/`.
- Each song gets its own bank and a compact wave archive. These hold only the
  samples the song plays. HGSS keeps its basic samples resident in the sound
  heap, as Platinum keeps its own, and both can't sit there at once. A sample
  that Platinum's basic wave archive also holds plays from that resident
  archive instead, as HGSS's songs play from theirs; that saves 40 to 80 KB
  a song. The importer reads Platinum's basic wave archive from the build.
- The field player loads a Kanto song's own bank and samples whenever the
  song changes, including when walking from one map to the next. Sinnoh's
  songs shared one bank, so Platinum didn't reload it there.
- The music players get HGSS's channels (1 to 10, 13 and 15), which the PSG
  and drum parts need.
- `SOUND_SYSTEM_HEAP_SIZE` grows by 160 KB, out of the main arena's spare
  room. That room was measured at 188 KB.
- Surf and the bicycle play HGSS's songs (`KANTO_SURF_BGM` and
  `KANTO_BICYCLE_BGM` in `include/data/kanto_sound.h`). Surf's is the
  largest field song and leaves 78 KB of the sound heap. That is enough for
  every sound effect group a menu or other sub-screen loads; the largest is
  about 33 KB.
- Battles play HGSS's Kanto music, as HGSS picks it: Kanto's wild, trainer
  and gym leader themes, HGSS's gym leader theme for the Elite Four, and its
  Champion and rival themes. The victory songs are HGSS's too: one for wild
  Pokémon, one for trainers and one for gym leaders, the Elite Four and the
  Champion. Sinnoh's legendaries, Team Galactic and the Battle Frontier keep
  Platinum's music. A battle song has 217 KB of the sound heap; the largest,
  Kanto's gym leader theme, leaves 17 KB.
- `nitrosfx` aligned the sound archive's files wrongly whenever its headers
  didn't end on a 32 byte boundary, and the game hung loading sounds at boot.
  This is fixed. Archives that were already aligned build the same.

Still to do:

- Confirm that the larger sound heap leaves enough main arena for every
  mode. The untested cases are Wi-Fi, the Union Room and the Battle Frontier.
- Trainer-encounter, evolution and other music still play Platinum's
  tracks. Only the map, Surf, bicycle, battle and victory music has been
  ported.
- HGSS's low HP music in battle isn't ported: Platinum has none.

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

Surf and the bicycle were tested on Route 21, Pallet Town and Route 1: each
song loads and starts, and the Bag and start menu open while Surf's plays.
Every battle song, then its victory song, then the map's song were played
through the calls a battle makes, and all of them load.

A wild battle with no Pokémon in the party goes to a black screen; a new
game needs its starter first.

Emulator testing used py-desmume with a temporary, uncommitted patch. The
patch skips the intro, names the player, gives a Pokémon, and registers the
Town Map to Y. It can also move the starting position into a given map.
py-desmume's save chip fails the game's check at boot, so the patch also skips
that check.
