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

# The release page groups the commits by kind, not by day as CHANGELOG.md does:
# on a long list "what changed" is what a reader looks for, and the dates of
# individual commits mean nothing to them. The conventional-commit type picks
# the bucket and is then dropped from the line, since the heading already says
# it; the scope, where present, survives as a bold lead.
grouped="$(mktemp)"
trap 'rm -f "$section" "$grouped"' EXIT
awk '
  BEGIN { n_brk = n_feat = n_fix = n_perf = n_other = 0; printed = 0 }
  function emit(title, arr, n,   i) {
    if (n == 0) return
    if (printed) print ""
    printed = 1
    print "### " title
    print ""
    for (i = 1; i <= n; i++) print arr[i]
  }
  /^### / { next }
  /^[[:space:]]*$/ { next }
  {
    entry = $0
    breaking = 0
    if ($0 ~ /^- /) {
      s = substr($0, 3)
      type = "other"
      scope = ""
      if (match(s, /^[a-z]+(\([^)]+\))?!?:[[:space:]]/)) {
        head = substr(s, 1, RLENGTH)
        rest = substr(s, RLENGTH + 1)
        sub(/:[[:space:]]*$/, "", head)
        breaking = (head ~ /!$/)
        sub(/!$/, "", head)
        if (match(head, /\([^)]+\)$/)) {
          scope = substr(head, RSTART + 1, RLENGTH - 2)
          type = substr(head, 1, RSTART - 1)
        } else {
          type = head
        }
        entry = "- " (scope != "" ? "**" scope "**: " : "") rest
      }
    }
    if (breaking)            brk[++n_brk] = entry
    else if (type == "feat") feat[++n_feat] = entry
    else if (type == "fix")  fix[++n_fix] = entry
    else if (type == "perf") perf[++n_perf] = entry
    else                     other[++n_other] = entry
  }
  END {
    emit("Modifiche incompatibili", brk, n_brk)
    emit("Novità", feat, n_feat)
    emit("Correzioni", fix, n_fix)
    emit("Prestazioni", perf, n_perf)
    emit("Altro", other, n_other)
  }
' "$section" > "$grouped"

pages_url="https://${repo%%/*}.github.io/${repo##*/}/"

body="$(awk -v repo="$repo" -v pages="$pages_url" -v version="$version" -v prev="$prev" -v secfile="$grouped" '
  NR == 1 && /^<!--/ { in_header = 1 }
  in_header { if (/-->/) in_header = 0; next }
  in_header == 0 && !started && /^[[:space:]]*$/ { next }
  { started = 1
    line = $0
    gsub(/\{\{REPO\}\}/, repo, line)
    gsub(/\{\{PAGES_URL\}\}/, pages, line)
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
