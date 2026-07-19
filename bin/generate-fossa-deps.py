#!/usr/bin/env python3
"""
Generate fossa-deps.yml from src/.env.dist.

Keeps FOSSA's remote-dependencies manifest (used for license/vuln scanning of
the vendored nginx/Lua modules) in sync with the versions actually pinned in
the Dockerfiles, instead of drifting out of date by hand.
"""

import sys
from pathlib import Path

from deps_manifest import DEPENDENCIES, STATIC_DEPENDENCIES

ENV_DIST_PATH = Path(__file__).parent.parent / "src" / ".env.dist"
FOSSA_DEPS_PATH = Path(__file__).parent.parent / "fossa-deps.yml"


def load_env_dist():
    """Parse VER_* values out of src/.env.dist."""
    versions = {}
    for line in ENV_DIST_PATH.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            versions[key] = value
    return versions


def main():
    versions = load_env_dist()

    lines = ["remote-dependencies:"]
    for dep in DEPENDENCIES:
        env_key = f"VER_{dep['key'].upper()}"
        if env_key not in versions:
            print(f"ERROR: {env_key} not found in {ENV_DIST_PATH}", file=sys.stderr)
            sys.exit(1)
        ver = versions[env_key]
        url = dep['tarball_pattern'].format(ver=ver)
        ref = "commits/master" if dep['is_commit'] else "tags"
        lines.append(f"# {dep['repo_url']}/{ref}")
        lines.append(f"- name: {dep['fossa_name']}")
        lines.append(f'  url: "{url}"')
        lines.append(f'  version: "{ver}"')
        lines.append("")

    for dep in STATIC_DEPENDENCIES:
        lines.append(f'- name: "{dep["fossa_name"]}"')
        lines.append(f'  url: "{dep["url"]}"')
        lines.append(f'  version: "{dep["version"]}"')
        lines.append("")

    FOSSA_DEPS_PATH.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
    print(f"Wrote {FOSSA_DEPS_PATH}")


if __name__ == "__main__":
    main()
