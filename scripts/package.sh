#!/usr/bin/env bash
# Package every skill in skills/ as a .skill file (a zip of the skill folder) into dist/.
# Usage: scripts/package.sh            -> dist/<name>.skill for each skill
#        scripts/package.sh read-the-map -> just that one
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
if [ $# -gt 0 ]; then names=("$@"); else names=($(ls skills)); fi
# Check every SKILL.md before packaging: the frontmatter must be valid YAML (strict
# parsers reject a plain description containing ": "; quote it), the name must match
# the folder, and the description must be 1,024 characters or fewer for uploads to save.
python3 - "${names[@]}" <<'PY'
import sys
try:
    import yaml
except ImportError:
    sys.exit("package.sh needs PyYAML for the frontmatter check: python3 -m pip install pyyaml")
bad = []
for n in sys.argv[1:]:
    text = open(f"skills/{n}/SKILL.md", encoding="utf-8").read()
    parts = text.split("---", 2)
    if not text.startswith("---") or len(parts) < 3:
        bad.append(f"{n}: no frontmatter"); continue
    try:
        fm = yaml.safe_load(parts[1])
    except yaml.YAMLError as e:
        bad.append(f"{n}: frontmatter is not valid YAML ({str(e).splitlines()[0]}); quote the description"); continue
    if not isinstance(fm, dict) or fm.get("name") != n:
        bad.append(f"{n}: name must be '{n}'")
    d = (fm or {}).get("description") or ""
    if not d:
        bad.append(f"{n}: no description")
    elif len(d) > 1024:
        bad.append(f"{n}: description is {len(d)} characters, over 1,024")
if bad:
    sys.exit("\n".join(bad))
PY
for n in "${names[@]}"; do
  [ -f "skills/$n/SKILL.md" ] || { echo "no SKILL.md in skills/$n" >&2; exit 1; }
  rm -f "dist/$n.skill"
  (cd skills && zip -q -X -r "../dist/$n.skill" "$n" -x '*.DS_Store')
  echo "dist/$n.skill"
done
