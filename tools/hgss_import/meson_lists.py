"""Helpers to append imported entries to pokeplatinum's hand-maintained file lists.

Every imported file name starts with "kanto_", so re-running the importer
first strips the previous import and then appends the new entries.
"""
import re
from pathlib import Path

PREFIX = "kanto_"


def update_meson_files(path, ext, names):
    """Append 'name' entries after the last '*.ext' entry of a files() list."""
    path = Path(path)
    lines = [l for l in path.read_text().splitlines() if f"'{PREFIX}" not in l]
    entry_re = re.compile(r"^(\s*)'[^']+\." + re.escape(ext) + r"'(,?)\s*$")
    last = max(i for i, l in enumerate(lines) if entry_re.match(l))
    indent = entry_re.match(lines[last]).group(1)
    if not lines[last].rstrip().endswith(","):
        lines[last] = lines[last].rstrip() + ","
    new = [f"{indent}'{n}'," for n in names]
    lines[last + 1:last + 1] = new
    path.write_text("\n".join(lines) + "\n")


def update_order(path, names):
    path = Path(path)
    lines = [l for l in path.read_text().splitlines() if not l.startswith(PREFIX)]
    path.write_text("\n".join(lines + list(names)) + "\n")


def update_enum_list(path, strip_prefix, names, before=None):
    """Insert enum names (e.g. into generated/maps.txt) before the `before` line, or at the end."""
    path = Path(path)
    lines = [l for l in path.read_text().splitlines() if not l.startswith(strip_prefix)]
    idx = next(i for i, l in enumerate(lines) if l.startswith(before)) if before else len(lines)
    lines[idx:idx] = list(names)
    path.write_text("\n".join(lines) + "\n")
