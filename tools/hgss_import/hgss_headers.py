"""Parse pokeheartgold's src/data/map_headers.h into a list of dicts."""
import re
from pathlib import Path

_ENTRY_RE = re.compile(r"\[(MAP_[A-Z0-9_]+)\]\s*=\s*\{(.*?)\n\s*\},", re.S)
_FIELD_RE = re.compile(r"\.(\w+)\s*=\s*([^,\n]+),")


def _map_ids(hgss_root):
    ids = {}
    for line in (Path(hgss_root) / "include/constants/maps.h").read_text().splitlines():
        m = re.match(r"#define\s+(MAP_\w+)\s+(\d+)", line)
        if m:
            ids[m.group(1)] = int(m.group(2))
    return ids


def load_headers(hgss_root):
    text = (Path(hgss_root) / "src/data/map_headers.h").read_text()
    ids = _map_ids(hgss_root)
    headers = []
    for name, body in _ENTRY_RE.findall(text):
        fields = {k: v.strip() for k, v in _FIELD_RE.findall(body)}
        fields["name"] = name
        fields["id"] = ids[name]
        headers.append(fields)
    headers.sort(key=lambda h: h["id"])
    return headers


if __name__ == "__main__":
    import sys
    hs = load_headers(sys.argv[1])
    print(len(hs))
    kanto = [h for h in hs if h["regionNo"] == "MAP_REGION_KANTO"]
    print(len(kanto), "kanto")
    for h in kanto:
        print(h["id"], h["name"], h["matrixId"].replace("NARC_map_matrix_map_matrix_", ""), h["areaDataBank"], h["mapType"])
