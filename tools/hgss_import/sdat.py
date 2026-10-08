"""Read the sequences, banks and wave archives of a Nitro sound archive (SDAT)."""
import struct


def _block(data, off):
    return data[off:off + struct.unpack_from("<I", data, off + 4)[0]]


def _symbols(data, symb_off, record):
    if not symb_off:
        return []
    rec_off = struct.unpack_from("<I", data, symb_off + 8 + 4 * record)[0]
    count = struct.unpack_from("<I", data, symb_off + rec_off)[0]
    names = []
    for i in range(count):
        name_off = struct.unpack_from("<I", data, symb_off + rec_off + 4 + 4 * i)[0]
        names.append(data[symb_off + name_off:data.index(b"\0", symb_off + name_off)].decode() if name_off else "")
    return names


def read(data):
    assert data[:4] == b"SDAT"
    symb_off, _, info_off, _, fat_off = struct.unpack_from("<IIIII", data, 0x10)
    fat_count = struct.unpack_from("<I", data, fat_off + 8)[0]
    files = []
    for i in range(fat_count):
        off, size = struct.unpack_from("<II", data, fat_off + 12 + 16 * i)
        files.append(data[off:off + size])

    def records(kind):
        rec_off = struct.unpack_from("<I", data, info_off + 8 + 4 * kind)[0]
        count = struct.unpack_from("<I", data, info_off + rec_off)[0]
        return [struct.unpack_from("<I", data, info_off + rec_off + 4 + 4 * i)[0] for i in range(count)]

    seqs, banks, wavarcs = [], [], []
    names = _symbols(data, symb_off, 0)
    for i, off in enumerate(records(0)):
        if not off:
            seqs.append(None)
            continue
        file_id, bank, volume, cpr, ppr, player = struct.unpack_from("<HxxHBBBB", data, info_off + off)
        seqs.append({"name": names[i] if i < len(names) else f"SEQ_{i}", "file": files[file_id], "bank": bank,
                     "volume": volume, "channelPriority": cpr, "playerPriority": ppr, "player": player})
    names = _symbols(data, symb_off, 2)
    for i, off in enumerate(records(2)):
        if not off:
            banks.append(None)
            continue
        file_id = struct.unpack_from("<H", data, info_off + off)[0]
        waves = list(struct.unpack_from("<4H", data, info_off + off + 4))
        banks.append({"name": names[i] if i < len(names) else f"BANK_{i}", "file": files[file_id], "waves": waves})
    names = _symbols(data, symb_off, 3)
    for i, off in enumerate(records(3)):
        if not off:
            wavarcs.append(None)
            continue
        file_id = struct.unpack_from("<I", data, info_off + off)[0] & 0xFFFFFF
        wavarcs.append({"name": names[i] if i < len(names) else f"WAVE_ARC_{i}", "file": files[file_id]})
    players = _symbols(data, symb_off, 4)
    return {"seqs": seqs, "banks": banks, "wavarcs": wavarcs, "players": players}


def swar_samples(data):
    """The SWAV sample blobs of a SWAR."""
    count = struct.unpack_from("<I", data, 0x38)[0]
    offsets = [struct.unpack_from("<I", data, 0x3C + 4 * i)[0] for i in range(count)] + [len(data)]
    return [data[offsets[i]:offsets[i + 1]] for i in range(count)]


def build_swar(samples):
    offsets, body = [], b""
    base = 0x3C + 4 * len(samples)
    for s in samples:
        offsets.append(base + len(body))
        body += s
    data_block = b"DATA" + struct.pack("<I", 0x2C + 4 * len(samples) + len(body)) + b"\0" * 32 + struct.pack("<I", len(samples))
    data_block += b"".join(struct.pack("<I", o) for o in offsets) + body
    return b"SWAR" + struct.pack("<IIHH", 0x0100FEFF, 0x10 + len(data_block), 0x10, 1) + data_block


def sbnk_note_defs(data):
    """Offsets (within data) of every note definition's (swav, swar) pair."""
    count = struct.unpack_from("<I", data, 0x38)[0]
    refs = []
    for i in range(count):
        kind = data[0x3C + 4 * i]
        off = struct.unpack_from("<H", data, 0x3C + 4 * i + 1)[0]
        if kind in (1,):  # PCM
            refs.append(off)
        elif kind == 16:  # drum set: low, high, then 12 byte entries (u16 type + note def)
            low, high = data[off], data[off + 1]
            for k in range(high - low + 1):
                if struct.unpack_from("<H", data, off + 2 + 12 * k)[0] == 1:
                    refs.append(off + 2 + 12 * k + 2)
        elif kind == 17:  # key split: 8 key bytes, then 12 byte entries
            regions = sum(1 for b in data[off:off + 8] if b)
            for k in range(regions):
                if struct.unpack_from("<H", data, off + 8 + 12 * k)[0] == 1:
                    refs.append(off + 8 + 12 * k + 2)
    return refs


def _varlen(data, i):
    value = 0
    while i < len(data):
        b = data[i]
        i += 1
        value = value << 7 | (b & 0x7F)
        if not b & 0x80:
            return value, i
    return value, i  # trailing padding


def sseq_programs(data):
    """Every program (instrument) an SSEQ selects, by scanning its commands."""
    off = struct.unpack_from("<I", data, 0x18)[0]
    i, programs = off, set()
    while i < len(data):
        cmd = data[i]
        i += 1
        if cmd in (0xA0, 0xA1, 0xA2):  # random / variable / conditional prefixes
            prefix, cmd = cmd, data[i]
            i += 1
        else:
            prefix = None
        if cmd < 0x80:  # note: velocity, duration
            i += 1
            if prefix == 0xA0:
                i += 4
            elif prefix == 0xA1:
                i += 1
            else:
                _, i = _varlen(data, i)
        elif cmd in (0x80, 0x81):  # wait, program change
            if prefix == 0xA0:
                i += 4
            elif prefix == 0xA1:
                i += 1
            else:
                value, i = _varlen(data, i)
                if cmd == 0x81:
                    programs.add(value)
        elif cmd == 0x93:
            i += 4
        elif cmd in (0x94, 0x95):
            i += 3
        elif 0xB0 <= cmd <= 0xBD:
            i += 1 + (4 if prefix == 0xA0 else 1 if prefix == 0xA1 else 2)
        elif 0xC0 <= cmd <= 0xD7:
            i += 4 if prefix == 0xA0 else 1
        elif 0xE0 <= cmd <= 0xE3:
            i += 4 if prefix == 0xA0 else 1 if prefix == 0xA1 else 2
        elif cmd in (0xFC, 0xFD, 0xFE):
            i += 2 if cmd == 0xFE else 0
        elif cmd == 0xFF:
            continue
    return programs


def sbnk_instrument_note_defs(data, program):
    """Offsets of the (swav, swar) pairs an instrument plays."""
    count = struct.unpack_from("<I", data, 0x38)[0]
    if program >= count:
        return []
    kind = data[0x3C + 4 * program]
    off = struct.unpack_from("<H", data, 0x3C + 4 * program + 1)[0]
    if kind == 1:
        return [off]
    refs = []
    if kind == 16:
        low, high = data[off], data[off + 1]
        for k in range(high - low + 1):
            if struct.unpack_from("<H", data, off + 2 + 12 * k)[0] == 1:
                refs.append(off + 2 + 12 * k + 2)
    elif kind == 17:
        regions = sum(1 for b in data[off:off + 8] if b)
        for k in range(regions):
            if struct.unpack_from("<H", data, off + 8 + 12 * k)[0] == 1:
                refs.append(off + 8 + 12 * k + 2)
    return refs
