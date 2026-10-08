"""Decode an HGSS map matrix binary (same layout as Platinum's)."""
import struct


def decode_matrix(data):
    w, h, has_headers, has_alt, name_len = data[:5]
    off = 5
    name = data[off:off + name_len].decode("ascii")
    off += name_len
    headers = altitudes = None
    if has_headers:
        headers = [list(struct.unpack_from(f"<{w}H", data, off + 2 * w * y)) for y in range(h)]
        off += 2 * w * h
    if has_alt:
        altitudes = [list(data[off + w * y:off + w * (y + 1)]) for y in range(h)]
        off += w * h
    maps = [list(struct.unpack_from(f"<{w}H", data, off + 2 * w * y)) for y in range(h)]
    off += 2 * w * h
    assert off == len(data), (off, len(data))
    return {"name": name, "width": w, "height": h, "headers": headers, "altitudes": altitudes, "maps": maps}
