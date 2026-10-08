#!/usr/bin/env python3
"""Import Kanto's field data from a pokeheartgold checkout into pokeplatinum.

Stage A (this file): land data, map texture sets, area data, building
models, building texture sets/model sets, building animations, the building
animation list and the building material/shape table.

Usage: tools/hgss_import/import_kanto.py <path-to-pokeheartgold>

All imported files are prefixed with "kanto_" and the script is idempotent:
it strips a previous import from every list it touches before appending.
"""
import argparse
import glob
import json
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from hgss_headers import load_headers  # noqa: E402
from hgss_matrix import decode_matrix  # noqa: E402
from meson_lists import update_enum_list, update_meson_files, update_order  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

PL = Path(__file__).resolve().parents[2]
BASE = Path(__file__).parent / "base"

# HGSS archives, see gs_project include/system/arc_tool.dat and mapresource.c.
HG_LAND_DATA = "files/a/0/6/5"
HG_AREA_DATA = "files/a/0/4/2"
HG_AREA_BUILD_MODEL = "files/a/0/4/3"
HG_AREA_TEX_SET = "files/a/0/4/4"
HG_BM_TEX_SET = "files/a/0/7/0"
HG_BM_FIELD = "files/fielddata/build_model/bm_field.narc"
HG_BM_ROOM = "files/fielddata/build_model/bm_room.narc"
HG_BM_FIELD_MATSHP = "files/fielddata/build_model/bm_field_matshp.dat"
HG_BM_ROOM_MATSHP = "files/fielddata/build_model/bm_room_matshp.dat"
HG_BM_INFO_OUT = "files/a/1/0/7"
HG_BM_INFO_IN = "files/a/1/0/8"
HG_BM_ANM = "files/a/1/0/6"
HG_GROUND_ANM = "files/a/1/4/0"

# The Kanto block of HGSS's world matrix (map_matrix_0000_EVERYWHERE), with a
# one block border so the filler terrain around Kanto's edge is drawn too.
KANTO_WORLD_X = range(21, 46)
KANTO_WORLD_Y = range(0, 17)

# Area that filler blocks (MAP_EVERYWHERE cells) are grouped with: they are
# drawn with whichever outdoor area the player is in.
FILLER_AREA = 18

OUTDOOR, INDOOR = "field", "room"

# HGSS tile behaviors whose IDs differ in Platinum.
TILE_BEHAVIOR_REMAP = {
    0x2C: 0x00,  # HGSS magma: no Platinum equivalent
    0x2D: 0x2C,  # HGSS reflective -> Platinum reflective
}

# HGSS and Platinum ship the same four area light files, but HGSS's area data
# stores a light type: AreaDataManager_GetAreaLightArchiveID maps it to the file.
HGSS_AREA_LIGHT = {0: 1, 1: 0, 2: 3}

ANIME_EXT = {b"BTA0": "nsbta", b"BCA0": "nsbca", b"BTP0": "nsbtp", b"BMA0": "nsbma", b"BVA0": "nsbva"}


def count_base_entries(order_file):
    return sum(1 for l in order_file.read_text().split() if not l.startswith("kanto_"))


def matrix_key(matrix_id):
    return matrix_id.replace("NARC_map_matrix_map_matrix_", "").removesuffix("_bin")


class Importer:
    def __init__(self, hg):
        self.hg = Path(hg)
        self.headers = load_headers(hg)
        self.kanto = [h for h in self.headers if h["regionNo"] == "MAP_REGION_KANTO"]
        self.by_id = {h["id"]: h for h in self.headers}
        self.matrices = {}
        for p in sorted(glob.glob(str(self.hg / "files/fielddata/mapmatrix/map_matrix/*.bin"))):
            key = re.search(r"map_matrix_(\d+(?:_\w+)?)\.bin", p).group(1)
            self.matrices[key] = decode_matrix(Path(p).read_bytes())
        self.area_data = read_narc(self.hg / HG_AREA_DATA)
        self.mapping = {}

    def narc(self, rel):
        return read_narc(self.hg / rel)

    # ------------------------------------------------------------------ areas
    def area(self, area_id):
        model_set, tex_set, ground_anm, inner_outer, light = struct.unpack("<HHHBB", self.area_data[area_id])
        return {"modelSet": model_set, "texSet": tex_set, "groundAnime": ground_anm,
                "set": OUTDOOR if inner_outer else INDOOR, "light": light}

    def collect(self):
        """Find the land data used by Kanto and the area each one is drawn with."""
        land_area = {}

        def use(land, area_id):
            if land == 0xFFFF:
                return
            land_area.setdefault(land, set()).add(int(area_id))

        world = self.matrices["0000_EVERYWHERE"]
        for y in KANTO_WORLD_Y:
            for x in KANTO_WORLD_X:
                header = self.by_id.get(world["headers"][y][x])
                if header is not None and header["regionNo"] == "MAP_REGION_KANTO":
                    use(world["maps"][y][x], header["areaDataBank"])
                else:
                    use(world["maps"][y][x], FILLER_AREA)

        for h in self.kanto:
            key = matrix_key(h["matrixId"])
            if key == "0000_EVERYWHERE":
                continue
            m = self.matrices[key]
            for y, row in enumerate(m["maps"]):
                for x, land in enumerate(row):
                    hid = m["headers"][y][x] if m["headers"] else h["id"]
                    area_id = self.by_id[hid]["areaDataBank"] if hid in self.by_id else h["areaDataBank"]
                    use(land, area_id)

        self.land_area = {}
        for land, areas in sorted(land_area.items()):
            sets = {self.area(a)["set"] for a in areas}
            if len(sets) != 1:
                sys.exit(f"land_data {land} is drawn with both building sets: {areas}")
            self.land_area[land] = sorted(areas)
        self.areas = sorted({int(h["areaDataBank"]) for h in self.kanto} | {a for v in self.land_area.values() for a in v})

    # -------------------------------------------------------------- buildings
    def import_buildings(self):
        bm = {OUTDOOR: self.narc(HG_BM_FIELD), INDOOR: self.narc(HG_BM_ROOM)}
        info = {OUTDOOR: self.narc(HG_BM_INFO_OUT), INDOOR: self.narc(HG_BM_INFO_IN)}
        lists = self.narc(HG_AREA_BUILD_MODEL)
        land = self.narc(HG_LAND_DATA)

        used = set()
        for a in self.areas:
            ar = self.area(a)
            lst = lists[ar["modelSet"]]
            count = struct.unpack_from("<H", lst)[0]
            used.update((ar["set"], m) for m in struct.unpack_from(f"<{count}H", lst, 2))
        for land_id, areas in self.land_area.items():
            s = self.area(areas[0])["set"]
            for model in self.land_props(land[land_id]):
                used.add((s, model))

        base_models = count_base_entries(PL / "res/field/props/models/map_prop_models.order")
        self.model_ids = {}
        names = []
        for i, (s, m) in enumerate(sorted(used)):
            self.model_ids[(s, m)] = base_models + i
            name = f"kanto_bm_{s}_{m:03}.nsbmd"
            names.append(name)
            (PL / "res/field/props/models" / name).write_bytes(bm[s][m])
        update_meson_files(PL / "res/field/props/models/meson.build", "nsbmd", names)
        update_order(PL / "res/field/props/models/map_prop_models.order", names)
        self.model_names = {k: names[v - base_models].replace(".", "_") for k, v in self.model_ids.items()}
        self.mapping["buildModels"] = {f"{s}/{m}": v for (s, m), v in self.model_ids.items()}

        self.import_building_animations(info, base_models, sorted(used))
        self.import_material_shapes(base_models, sorted(used))

    def import_building_animations(self, info, base_models, used):
        anims = self.narc(HG_BM_ANM)
        base_anims = count_base_entries(PL / "res/field/props/animations/prop_animations.order")
        anim_ids = {}
        names = []
        records = []
        for s, m in used:
            rec = info[s][m] if m < len(info[s]) else b"\xff\xff" + b"\0" * 6 + b"\xff" * 16
            flg, typ, suicide, repeat, door, _, anm_num, set_num = rec[:8]
            codes = list(struct.unpack_from("<4i", rec, 8))
            for n, c in enumerate(codes):
                if c < 0:
                    continue
                if c not in anim_ids:
                    data = anims[c]
                    name = f"kanto_bm_anime_{c:03}.{ANIME_EXT[data[:4]]}"
                    anim_ids[c] = base_anims + len(names)
                    names.append(name)
                    (PL / "res/field/props/animations" / name).write_bytes(data)
                codes[n] = anim_ids[c]
            # Platinum MapPropAnimeListFile: hasAnimations, flags, isBicycleSlope, dummy, ids[4].
            # HGSS F3D_MDL_INFO adds door/anmNum/setNum, which the engine port reads from
            # the dummy byte (door) for now; type 8 (time-of-day animation) is kept as-is.
            records.append(struct.pack("<BBBB4i", flg, typ, suicide, door, *codes))
        # HGSS keeps the terrain animations (NSBTA played on the land models of
        # an area) in their own archive; they ride along in the prop one here.
        self.ground_anim_ids = {}
        for g, data in enumerate(self.narc(HG_GROUND_ANM)):
            self.ground_anim_ids[g] = base_anims + len(names)
            name = f"kanto_ground_anime_{g:03}.nsbta"
            names.append(name)
            (PL / "res/field/props/animations" / name).write_bytes(data)
        self._append_animations(names)
        base = read_narc(BASE / "bm_anime_list.narc")
        assert len(base) == base_models, (len(base), base_models)
        (PL / "res/prebuilt/arc/bm_anime_list.narc").write_bytes(write_narc(base + records))
        self.mapping["buildAnimations"] = {str(k): v for k, v in anim_ids.items()}

    def _append_animations(self, names):
        meson = PL / "res/field/props/animations/meson.build"
        lines = [l for l in meson.read_text().splitlines() if "'kanto_" not in l]
        entry_re = re.compile(r"^(\s*)'[^']+\.nsb(ta|ca|tp|ma|va)'(,?)\s*$")
        last = max(i for i, l in enumerate(lines) if entry_re.match(l))
        indent = entry_re.match(lines[last]).group(1)
        if not lines[last].rstrip().endswith(","):
            lines[last] = lines[last].rstrip() + ","
        lines[last + 1:last + 1] = [f"{indent}'{n}'," for n in names]
        meson.write_text("\n".join(lines) + "\n")
        update_order(PL / "res/field/props/animations/prop_animations.order", names)

    def import_material_shapes(self, base_models, used):
        def parse(data):
            nloc, nids = struct.unpack_from("<HH", data)
            locs = [struct.unpack_from("<HH", data, 4 + 4 * i) for i in range(nloc)]
            ids = data[4 + 4 * nloc:4 + 4 * nloc + 4 * nids]
            return locs, ids

        locs, ids = parse((BASE / "build_model_matshp.dat").read_bytes())
        assert len(locs) == base_models
        src = {OUTDOOR: parse((self.hg / HG_BM_FIELD_MATSHP).read_bytes()),
               INDOOR: parse((self.hg / HG_BM_ROOM_MATSHP).read_bytes())}
        ids = bytearray(ids)
        for s, m in used:
            slocs, sids = src[s]
            count, index = slocs[m] if m < len(slocs) else (0, 0)
            locs.append((count, len(ids) // 4 if count else 0))
            ids += sids[4 * index:4 * (index + count)]
        out = struct.pack("<HH", len(locs), len(ids) // 4)
        out += b"".join(struct.pack("<HH", *l) for l in locs) + bytes(ids)
        (PL / "res/prebuilt/fielddata/build_model/build_model_matshp.dat").write_bytes(out)

    # ----------------------------------------------------- area texture sets
    def import_areas(self):
        tex = self.narc(HG_AREA_TEX_SET)
        bm_tex = self.narc(HG_BM_TEX_SET)
        lists = self.narc(HG_AREA_BUILD_MODEL)

        tex_sets = sorted({self.area(a)["texSet"] for a in self.areas})
        tex_names = {t: f"kanto_map_texture_set_{t:03}" for t in tex_sets}
        for t, name in tex_names.items():
            (PL / "res/field/maps/texture_sets" / f"{name}.nsbtx").write_bytes(tex[t])
        update_meson_files(PL / "res/field/maps/texture_sets/meson.build", "nsbtx", [f"{n}.nsbtx" for n in tex_names.values()])
        update_order(PL / "res/field/maps/texture_sets/map_texture_sets.order", list(tex_names.values()))

        # Platinum indexes the prop model set and prop texture set archives with the
        # same ID, so both get the same appended position.
        model_sets = sorted({self.area(a)["modelSet"] for a in self.areas})
        set_names = {}
        texset_names = []
        for ms in model_sets:
            name = f"kanto_prop_model_set_{ms:03}"
            set_names[ms] = name
            count = struct.unpack_from("<H", lists[ms])[0]
            models = struct.unpack_from(f"<{count}H", lists[ms], 2)
            s = self.area(next(a for a in self.areas if self.area(a)["modelSet"] == ms))["set"]
            data = {"mapPropModels": [self.model_names[(s, m)] for m in models]}
            (PL / "res/field/props/model_sets" / f"{name}.json").write_text(json.dumps(data, indent=4) + "\n")
            texset = f"kanto_prop_texture_set_{ms:03}.nsbtx"
            texset_names.append(texset)
            (PL / "res/field/props/texture_sets" / texset).write_bytes(bm_tex[ms])
        update_meson_files(PL / "res/field/props/model_sets/meson.build", "json", [f"{n}.json" for n in set_names.values()])
        update_order(PL / "res/field/props/model_sets/prop_model_sets.order", list(set_names.values()))
        update_meson_files(PL / "res/field/props/texture_sets/meson.build", "nsbtx", texset_names)
        update_order(PL / "res/field/props/texture_sets/prop_texture_sets.order", texset_names)

        area_names = {}
        for a in self.areas:
            ar = self.area(a)
            name = f"kanto_area_data_{a:03}"
            area_names[a] = name
            data = {
                "mapPropSet": set_names[ar["modelSet"]],
                "mapTextureSet": tex_names[ar["texSet"]],
                # Platinum's unused area field sits where HGSS keeps the ground animation;
                # it holds the prop animation archive ID + 1, or 0 for none.
                "dummy": 0 if ar["groundAnime"] == 0xFFFF else self.ground_anim_ids[ar["groundAnime"]] + 1,
                "lightingSet": f"lighting_set_{HGSS_AREA_LIGHT[ar['light']]:03}",
            }
            (PL / "res/field/area_data" / f"{name}.json").write_text(json.dumps(data, indent=4) + "\n")
        update_meson_files(PL / "res/field/area_data/meson.build", "json", [f"{n}.json" for n in area_names.values()])
        update_order(PL / "res/field/area_data/area_data.order", list(area_names.values()))
        self.area_names = area_names
        self.mapping["areas"] = area_names

    # -------------------------------------------------------------- land data
    @staticmethod
    def land_sections(data):
        attrs, props, model, bdhc = struct.unpack_from("<4I", data)
        magic, bgs = struct.unpack_from("<HH", data, 16)
        assert magic == 0x1234, hex(magic)
        off = 20 + bgs
        sections = []
        for size in (attrs, props, model, bdhc):
            sections.append(data[off:off + size])
            off += size
        assert off == len(data)
        return sections

    @classmethod
    def land_props(cls, data):
        props = cls.land_sections(data)[1]
        return [struct.unpack_from("<i", props, o)[0] for o in range(0, len(props), 0x30)]

    def import_land_data(self):
        land = self.narc(HG_LAND_DATA)
        names = []
        enum_names = []
        self.land_names = {}
        for land_id, areas in self.land_area.items():
            s = self.area(areas[0])["set"]
            attrs, props, model, bdhc = self.land_sections(land[land_id])
            attrs = bytearray(attrs)
            for o in range(0, len(attrs), 2):
                behavior = attrs[o]
                if behavior in TILE_BEHAVIOR_REMAP:
                    attrs[o] = TILE_BEHAVIOR_REMAP[behavior]
            props = bytearray(props)
            for o in range(0, len(props), 0x30):
                old = struct.unpack_from("<i", props, o)[0]
                struct.pack_into("<i", props, o, self.model_ids[(s, old)])
            out = struct.pack("<4I", len(attrs), len(props), len(model), len(bdhc)) + attrs + props + model + bdhc
            name = f"kanto_map_data_{land_id:03}.bin"
            (PL / "res/field/maps/data" / name).write_bytes(out)
            names.append(name)
            enum_names.append(f"MAP_KANTO_{land_id:03}")
            self.land_names[land_id] = f"MAP_KANTO_{land_id:03}"
        update_meson_files(PL / "res/field/maps/data/meson.build", "bin", names)
        update_order(PL / "res/field/maps/data/map_data.order", names)
        update_enum_list(PL / "generated/maps.txt", "MAP_KANTO_", enum_names, before="MAP_NONE")
        self.mapping["landData"] = self.land_names

    def run(self):
        self.collect()
        self.import_buildings()
        self.import_areas()
        self.import_land_data()
        out = Path(__file__).parent / "kanto_mapping.json"
        out.write_text(json.dumps(self.mapping, indent=2, default=str) + "\n")
        print(f"{len(self.land_area)} land data, {len(self.areas)} areas, {len(self.model_ids)} building models")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("hgss", help="path to a pokeheartgold checkout")
    Importer(parser.parse_args().hgss).run()


if __name__ == "__main__":
    main()
