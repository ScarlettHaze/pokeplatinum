"""Minimal NSBTX (TEX0) reader, enough for 4 bit field sprite textures."""
import struct

def read_dict(d, off):
    # NNS G3D dictionary: header, ptree, then data entries, then names
    _, count = struct.unpack_from('<BB', d, off)
    size = struct.unpack_from('<H', d, off + 2)[0]
    ptree_off = off + 4 + 4 + 4 * (count + 1)  # skip header + ptree
    entsize, names_off = struct.unpack_from('<HH', d, ptree_off)
    data = [d[ptree_off + 4 + i * entsize: ptree_off + 4 + (i + 1) * entsize] for i in range(count)]
    names = [d[ptree_off + names_off + 16 * i: ptree_off + names_off + 16 * (i + 1)].rstrip(b'\0').decode('ascii', 'replace') for i in range(count)]
    return list(zip(names, data))

def read(d):
    assert d[:4] == b'BTX0'
    tex0 = struct.unpack_from('<I', d, 0x10)[0]
    t = d[tex0:]
    assert t[:4] == b'TEX0'
    tex_data_size = struct.unpack_from('<H', t, 0x0C)[0] << 3
    tex_dict_off = struct.unpack_from('<H', t, 0x0E)[0]
    tex_data_off = struct.unpack_from('<I', t, 0x14)[0]
    pal_size = struct.unpack_from('<I', t, 0x30)[0] << 3
    pal_dict_off = struct.unpack_from('<I', t, 0x34)[0]
    pal_data_off = struct.unpack_from('<I', t, 0x38)[0]
    textures = []
    for name, ent in read_dict(t, tex_dict_off):
        param = struct.unpack_from('<I', ent)[0]
        off = (param & 0xFFFF) << 3
        w = 8 << ((param >> 20) & 7); h = 8 << ((param >> 23) & 7); fmt = (param >> 26) & 7
        textures.append((name, fmt, w, h, t[tex_data_off + off: tex_data_off + off + w * h * {3: 4, 4: 8, 2: 2}.get(fmt, 8) // 8]))
    palettes = []
    for name, ent in read_dict(t, pal_dict_off):
        off = struct.unpack_from('<H', ent)[0] << 3
        palettes.append((name, t[pal_data_off + off: pal_data_off + off + 32]))
    return textures, palettes
