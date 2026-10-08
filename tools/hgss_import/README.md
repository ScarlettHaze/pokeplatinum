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
5. `import_kanto_town_map.py`: the Town Map.
6. `import_kanto_sprites.py`: overworld sprites for the player and NPCs.
7. `import_kanto_music.py`: map music.
8. `import_kanto_scripts.py`: text, signs, NPCs, items, marts and scripts.
   It reads sound IDs from `build/res/sound/pl_sound_data.naix`, so build
   the ROM once first.

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
- **Sprites:**
  - The player is Ethan or Lyra in every state.
  - 120 NPC and Pokémon sprites are imported as `OBJ_EVENT_GFX_KANTO_*`.
    `kanto_sprites.json` records the mapping from HGSS's sprite IDs.
  - Snorlax, the Pokémon League door and the stop sign are 64×64 still
    objects, set up like Platinum's Regigigas. Apricorn trees are still
    objects too, showing the bare tree: HGSS's apricorns and the tree's shake
    come from its apricorn save data and scripts, which are part of the
    scripts job below.
- **Text, events and scripts** (`import_kanto_scripts.py`):
  - Every Kanto message bank becomes a Platinum text bank
    (`res/text/kanto_*.json`). The message IDs stay HGSS's.
  - Every Kanto map has HGSS's NPCs, signs, hidden items, item balls,
    Cut trees, Rock Smash rocks, Strength boulders and step triggers.
  - HGSS's map and init scripts are translated to Platinum's script commands
    (`kanto_scripts.py`, output in `res/field/scripts/kanto_scripts_*.s`).
    551 script entries run as in HGSS. The other 241 need something Platinum
    lacks: an NPC or sign with one of those says the first line of its
    script, anything else does nothing. `kanto_scripts_report.txt` lists
    each one and why.
  - HGSS's flags and vars use Platinum's that only Sinnoh's map scripts used.
    `kanto_vars_flags.json` records which. Map-temporary flags and vars,
    daily flags, fly flags and the game clear flag map to Platinum's
    equivalents. Kanto's flags that HGSS sets in a new game are set in
    Platinum's new game script too.
  - Item balls join `scripts_visible_items.s`. Kanto's 91 hidden items
    replace Sinnoh's in the hidden items table
    (`include/data/field/kanto_hidden_items.h`). Kanto's specialty marts join
    Platinum's (`include/data/kanto_marts.h`).
  - Signs use HGSS's signpost graphics (`kanto_signs.py`), so map and arrow
    signs show HGSS's pictures.
  - Pokémon Center nurses and Poké Marts use Platinum's common scripts.

## Left to do

Smallest first.

### 1. Music

Done:

- `import_kanto_music.py` extracts the 36 Kanto songs from HGSS's sound
  archive into `res/sound/kanto/`.
- Each song gets its own bank and a compact wave archive. These hold only the
  samples the song plays. HGSS's basic samples differ from Platinum's, and
  both can't sit in the sound heap at once.
- The field player loads a Kanto song's own bank and samples whenever the
  song changes, including when walking from one map to the next. Sinnoh's
  songs shared one bank, so Platinum didn't reload it there.
- The music players get HGSS's channels (1 to 10, 13 and 15), which the PSG
  and drum parts need.
- `SOUND_SYSTEM_HEAP_SIZE` grows by 160 KB, out of the main arena's spare
  room. That room was measured at 188 KB.

Still to do:

- Confirm that the larger sound heap leaves enough main arena for every
  mode. The untested cases are Wi-Fi, the Union Room and the Battle Frontier.
- Battle, trainer-encounter, evolution and other music still play Platinum's
  tracks. Only the map music has been ported.
- Surf and bicycle music still play Platinum's songs.

### 2. Trainers and the rest of the scripts (the biggest job)

- **Trainers:** HGSS's trainers and parties aren't imported. The 176 trainer
  NPCs stand where HGSS has them but don't battle, and gym leaders, the
  Elite Four and the Champion don't battle either. This needs HGSS's
  trainer data, classes and pictures in Platinum's trainer table, and
  `TrainerBattle` and trainer flags in `kanto_scripts.py`.
- **Missing items:** Platinum lacks some Kanto story items (Machine Part,
  Pass, Lost Item, Rage Candy Bar, the GB Sounds and others), so their
  quests stop. 4 item balls and 1 hidden item with such items are left out.
- **HGSS-only features** behind most of the 241 stand-ins: Cameron's photos,
  the phone and Pokégear, the Game Corner, the Vermilion Gym puzzle, NPC
  trades, Pal Park, Rotom's forms, static encounter outcomes, elevators and
  department store floors. Each needs a Platinum version of the command.
- **Pokémon Center link rooms:** HGSS's union room, wireless and Wi-Fi NPCs,
  Teala and the delivery men stand in place without scripts, and their
  init scripts are dropped.
- **Healing animation:** `healing_machine_animation/pokecenter.c` falls back
  to HGSS's healing machine, Poké Ball and screen models in Kanto. This
  change is not yet compiled or tested.
- **Music in scripts:** scenes that change music in HGSS keep the map's
  music; HGSS-only sound effects are dropped.
- **The rival.** Platinum's intro still names Barry and shows his picture.
- **Apricorn trees:** HGSS's apricorn save data, picking apricorns, and the
  trees' apricorn and shake sprites.
- **A starter:** Kanto has no starter event, so a new game has no Pokémon.

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
lighting, animations, a wild battle, the Town Map and the sprites. Scripts
were tested on Pallet Town's sign and NPCs, Red's house, and the Viridian
City Pokémon Center and Poké Mart. The other maps build, but nobody has
walked them yet.

Emulator testing used py-desmume with a temporary, uncommitted patch. The
patch skips the intro, names the player, gives a Pokémon, and registers the
Town Map to Y. It can also move the starting position into a given map.
