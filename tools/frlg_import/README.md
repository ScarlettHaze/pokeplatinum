# FRLG's events on HGSS's Kanto

FRLG's story on the Kanto maps that `tools/hgss_import` brings in from HGSS.
FRLG's text, NPCs, signs and scripts come from
[pokefirered](https://github.com/pret/pokefirered).

    tools/frlg_import/import_frlg.py <path-to-pokefirered>

Run it after `tools/hgss_import` (which leaves the Kanto maps with warps
only). For each map in its `MAPS` table it:

- converts the FRLG map's `text.inc` to `res/text/frlg_<map>.json`
  (`frlg_text.py`). The words stay FRLG's; the spelling is the DS games'
  (POKéMON is Pokémon, OAK is Oak). `{PLAYER}` is string buffer 0,
  `{RIVAL}` buffer 1, `{STR_VAR_1}` buffer 2;
- writes the map's NPCs, signs and triggers into its events file, keeping
  the warps. Events name their script by label;
- points the map header at `scripts_frlg_<map>` and the text bank.

The scripts, `res/field/scripts/scripts_frlg_*.s`, are written by hand from
FRLG's. HGSS's maps are laid out differently, so every walk and trigger is
fitted to HGSS's map; each script file says how.

## Done

- **Pallet Town:** the two townspeople, the signs, and Oak stopping the
  player at the way out to Route 1 and leading them to his lab.
- **Red's house:** Mom (and her healing after the rival battle), the TV and
  the NES.
- **Blue's house:** Daisy.
- **Oak's lab:** the starter choice on the desk, nicknaming, the rival taking
  his starter, the first rival battle (win or lose), the aides, the e-mail
  and the bookshelves.
- **Route 1:** the Poké Mart clerk's Potion, the boy and the sign.

Also:

- FRLG's flags and variables take free Platinum ones in
  `generated/vars_flags.txt` (`FLAG_HIDE_OAK_IN_PALLET_TOWN` and so on).
- The lab rival's three trainers take three dummy trainer slots, since every
  trainer needs a defeated flag. The rival class shows HGSS's Blue.
- `VAR_PLAYER_STARTER` maps to the rival's starter as in FRLG.

## Differences from FRLG

- The Poké Balls sit on the desk at the back of HGSS's lab, so the player
  picks one from below it, and Oak stands in front of the desk. The balls
  are signs on the desk tiles (objects there can't be talked to), as in
  HGSS.
- The rival's win line, shown in battle in FRLG, comes after the battle.
- Mom's and Daisy's later scenes, the Town Map, Oak's Parcel, the Pokédex,
  the bedroom PC's item storage and the sign lady blocking the sign aren't
  ported yet.
- Music comes from HGSS: Oak's theme, and Silver's encounter theme for the
  rival.
