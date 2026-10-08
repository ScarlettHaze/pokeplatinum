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

### 2. Signs, NPCs, items and story events (the biggest job)

Kanto maps have warps but no other events. HGSS's scripts use HGSS's script
commands, so they have to be ported to Platinum's script system. This covers:

- Background events: signs and hidden items.
- Object events: NPCs, trainers and item balls. The sprites are ready (see
  `kanto_sprites.json`). The `SPRITE_VAR_*` sprites are set by scripts.
- Coordinate triggers.
- Map scripts and their text. The text comes from HGSS's message banks; the
  headers currently use a placeholder text bank.
- Flags and vars. HGSS's flags have to be mapped to free Platinum flags.
- Trainers and their parties, gym leaders, the Elite Four and Champion,
  marts, and Pokémon Center healing.
- The rival. Platinum's intro still names Barry and shows his picture.
- Apricorn trees: HGSS's apricorn save data, picking apricorns, and the
  trees' apricorn and shake sprites.

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
lighting, animations, a wild battle, the Town Map and the sprites. The
other 197 maps build, but nobody has walked them yet.

Emulator testing used py-desmume with a temporary, uncommitted patch. The
patch skips the intro, names the player, gives a Pokémon, and registers the
Town Map to Y.
