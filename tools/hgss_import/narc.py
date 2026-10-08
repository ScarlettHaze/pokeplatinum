import struct, sys
def read_narc(path):
    d = open(path,'rb').read()
    assert d[:4]==b'NARC', path
    off = struct.unpack_from('<H', d, 0xC)[0]
    # BTAF
    assert d[off:off+4]==b'BTAF'
    sz, n = struct.unpack_from('<IH', d, off+4)
    fat = [struct.unpack_from('<II', d, off+12+8*i) for i in range(n)]
    off += sz
    assert d[off:off+4]==b'BTNF'
    off += struct.unpack_from('<I', d, off+4)[0]
    assert d[off:off+4]==b'GMIF'
    base = off+8
    return [d[base+s:base+e] for s,e in fat]
if __name__=='__main__':
    fs = read_narc(sys.argv[1]); print(len(fs), 'files')
    for i in map(int, sys.argv[2:]):
        f=fs[i]; print(i, len(f), f[:48].hex(' '))


def write_narc(files):
    """Build a NARC with no file names, matching nitroarc's unnamed layout."""
    fat = bytearray()
    img = bytearray()
    for f in files:
        start = len(img)
        img += f
        fat += struct.pack("<II", start, len(img))
        img += b"\xff" * (-len(img) % 4)
    btaf = b"BTAF" + struct.pack("<IHH", 12 + len(fat), len(files), 0) + fat
    btnf = b"BTNF" + struct.pack("<IIHH", 16, 4, 0, 1)
    gmif = b"GMIF" + struct.pack("<I", 8 + len(img)) + img
    body = btaf + btnf + gmif
    return b"NARC" + struct.pack("<HHIHH", 0xFFFE, 0x0100, 16 + len(body), 16, 3) + body
