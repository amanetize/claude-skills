#!/usr/bin/env bash
# Rebuilds skills/ and licenses/ from the repos listed in upstream.tsv.
# Bumps the plugin version when anything changed, so Claude Code sees an update.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

out="$work/out"
mkdir -p "$out/skills" "$out/licenses"
lock="$out/upstream.lock"
: > "$lock"

# Prints a frontmatter field of a SKILL.md, joining folded (>) or literal (|) values onto one line.
field() {
  awk -v key="$2" '
    NR == 1 && $0 != "---" { exit }
    NR > 1 && $0 == "---" { exit }
    folding && /^[[:space:]]/ { sub(/^[[:space:]]+/, ""); value = value (value == "" ? "" : " ") $0; next }
    folding { exit }
    $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      if ($0 ~ /^[>|][-+]?$/) { folding = 1; next }
      value = $0; exit
    }
    END { gsub(/^["\047]|["\047]$/, "", value); print value }
  ' "$1"
}

# Copies a skill folder without symlinks or git metadata, so nothing can point outside it.
copy_skill() {
  cp -R "$1" "$2"
  find "$2" -type l -delete
  rm -rf "$2/.git"
}

bundles=()

while read -r repo from to _; do
  [[ -z "$repo" || "$repo" == \#* ]] && continue
  slug="${repo//\//__}"
  src="$work/src/$slug"
  echo "Fetching $repo"
  git clone -q --depth 1 "https://github.com/$repo" "$src"
  echo "$repo $(git -C "$src" rev-parse HEAD)" >> "$lock"

  for f in LICENSE LICENSE.md LICENSE.txt; do
    if [[ -f "$src/$f" ]]; then cp "$src/$f" "$out/licenses/$slug.txt"; break; fi
  done

  found=0
  for dir in "$src/$from"/*/; do
    [[ -f "$dir/SKILL.md" ]] || continue
    name="$(basename "$dir")"
    if [[ "$to" == "*" ]]; then
      dest="$out/skills/$name"
    else
      dest="$out/skills/$to/$name"
    fi
    if [[ -e "$dest" ]]; then
      echo "Two sources provide a skill named '$name' at ${dest#"$out/"}. Rename one in upstream.tsv." >&2
      exit 1
    fi
    mkdir -p "$(dirname "$dest")"
    copy_skill "$dir" "$dest"
    if [[ "$to" != "*" ]]; then
      # Bundled skills are read through the generated router, so their own SKILL.md
      # becomes plain instructions instead of a second, competing skill.
      mv "$dest/SKILL.md" "$dest/INSTRUCTIONS.md"
    fi
    found=$((found + 1))
  done
  if (( found == 0 )); then
    echo "No skills found in $repo/$from. Did the repo change its layout?" >&2
    exit 1
  fi
  echo "  $found skills"
  [[ "$to" != "*" ]] && bundles+=("$to")
done < "$root/upstream.tsv"

# One router SKILL.md per bundle, listing every bundled skill by its own description.
for to in ${bundles[@]+"${bundles[@]}"}; do
  bundle="${to%%/*}"
  sub="${to#*/}"
  router="$out/skills/$bundle/SKILL.md"
  [[ -f "$router" ]] && continue

  rows=""
  titles=()
  count=0
  for dir in "$out/skills/$bundle/$sub"/*/; do
    name="$(basename "$dir")"
    desc="$(field "$dir/INSTRUCTIONS.md" description)"
    rows+="| \`$name\` | $desc |"$'\n'
    titles+=("${name//-/ }")
    count=$((count + 1))
  done
  list="$(IFS=,; echo "${titles[*]}" | sed 's/,/, /g')"

  cat > "$router" <<EOF
---
name: $bundle
description: Software engineering rules distilled from $count classic books ($list). Use when designing, implementing, refactoring, testing, or reviewing code, architecture, domain models, data systems, or production reliability.
---

# ${bundle//-/ }

Rules from $count books, one folder each under \`$sub/\`. Do not load them all.

1. Pick the one book whose description below fits the task best. Take a second only if the task clearly spans two areas.
2. Read \`$sub/<book>/INSTRUCTIONS.md\` and follow it. It says which rule file to load.
3. When books overlap (for example several on domain-driven design), prefer the most specific match.

| Book | Use when |
|---|---|
$rows
EOF
  echo "Generated router for $bundle ($count books)"
done

changed=0
for part in skills licenses upstream.lock; do
  if ! diff -rq "$root/$part" "$out/$part" > /dev/null 2>&1; then changed=1; fi
done

if (( changed == 0 )); then
  echo "No upstream changes."
  exit 0
fi

rm -rf "$root/skills" "$root/licenses"
cp -R "$out/skills" "$out/licenses" "$out/upstream.lock" "$root/"

manifest="$root/.claude-plugin/plugin.json"
version="$(jq -r .version "$manifest")"
next="${version%.*}.$(( ${version##*.} + 1 ))"
jq --arg v "$next" '.version = $v' "$manifest" > "$work/plugin.json"
mv "$work/plugin.json" "$manifest"
echo "Updated skills, plugin version $version -> $next"
