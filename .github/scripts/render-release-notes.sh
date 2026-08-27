#!/usr/bin/env bash
#
# Render the body of a release page: fills .github/RELEASE_TEMPLATE.md with the
# CHANGELOG.md section for the given version.
#
#   .github/scripts/render-release-notes.sh <version> [previous-version]
#
# The previous version defaults to the highest v* tag that isn't this release.
# Exits non-zero when CHANGELOG.md has no section for <version>, so a release
# can't go out undocumented.

set -euo pipefail

version="${1:?usage: render-release-notes.sh <version> [previous-version]}"
prev="${2:-}"

root="$(git rev-parse --show-toplevel)"
template="$root/.github/RELEASE_TEMPLATE.md"
changelog="$root/CHANGELOG.md"

for f in "$template" "$changelog"; do
  [ -f "$f" ] || { echo "::error::missing $f" >&2; exit 1; }
done

repo="${GITHUB_REPOSITORY:-}"
if [ -z "$repo" ]; then
  repo="$(git remote get-url origin | sed -E 's#(git@[^:]+:|https://[^/]+/)##; s#\.git$##')"
fi

if [ -z "$prev" ]; then
  prev="$(git tag --list 'v*' --sort=-v:refname | grep -vx "v${version}" | head -n1 | sed 's/^v//')"
fi
[ -n "$prev" ] || { echo "::error::no previous tag found; pass it as the 2nd argument" >&2; exit 1; }

# The section runs from '## [<version>]' to the next h2 or to the link block.
section="$(mktemp)"
trap 'rm -f "$section"' EXIT
awk -v ver="$version" '
  index($0, "## [" ver "]") == 1 { found = 1; next }
  found && /^## / { exit }                 # next version section
  found && /^\[[^][]+\]:[[:space:]]/ { exit }  # link reference block at the bottom
  found { print }
' "$changelog" \
  | sed -e '/[^[:space:]]/,$!d' | tac | sed -e '/[^[:space:]]/,$!d' | tac > "$section"

if [ ! -s "$section" ]; then
  echo "::error::CHANGELOG.md has no '## [$version]' section (or it is empty)" >&2
  exit 1
fi

body="$(awk -v repo="$repo" -v version="$version" -v prev="$prev" -v secfile="$section" '
  NR == 1 && /^<!--/ { in_header = 1 }
  in_header { if (/-->/) in_header = 0; next }
  in_header == 0 && !started && /^[[:space:]]*$/ { next }
  { started = 1
    line = $0
    gsub(/\{\{REPO\}\}/, repo, line)
    gsub(/\{\{VERSION\}\}/, version, line)
    gsub(/\{\{PREV_VERSION\}\}/, prev, line)
    if (index(line, "{{CHANGELOG}}") > 0) {
      while ((getline s < secfile) > 0) print s
      close(secfile)
      next
    }
    print line
  }
' "$template")"

if printf '%s' "$body" | grep -q '{{'; then
  echo "::error::unsubstituted placeholder left in the rendered notes:" >&2
  printf '%s' "$body" | grep -n '{{' >&2
  exit 1
fi

printf '%s\n' "$body"
