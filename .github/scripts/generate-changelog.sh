#!/usr/bin/env bash
#
# Regenerate CHANGELOG.md from the git history: one line per commit, grouped by
# tag and, inside a tag, by day.
#
#   .github/scripts/generate-changelog.sh [next-version]
#
# Without arguments the commits made after the latest tag land under
# '## [Unreleased]'. With <next-version> they land in a new '## [<version>]'
# section instead, which is the form the release page is built from.
#
# The release workflow runs this itself, so there is normally nothing to do by
# hand; run it manually only to preview the file, or to update it after a
# release cut from a specific commit or tag, where the workflow has no branch to
# push to.
#
# The whole file is rewritten every time, so don't hand-edit it. Run
# `git fetch --tags` first: a tag the workflow created on GitHub but that the
# local clone hasn't fetched would silently merge into the wrong section.

set -euo pipefail

next="${1:-}"
if [ -n "$next" ] && [[ ! "$next" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.]+)?$ ]]; then
  echo "error: invalid version '$next' (expected e.g. 2.0.3, without a leading v)" >&2
  exit 1
fi

root="$(git rev-parse --show-toplevel)"
cd "$root"

repo="${GITHUB_REPOSITORY:-}"
if [ -z "$repo" ]; then
  repo="$(git remote get-url origin | sed -E 's#(git@[^:]+:|https://[^/]+/)##; s#\.git$##')"
fi
base="https://github.com/$repo"

mapfile -t tags < <(git tag --list 'v*' --sort=-v:refname)
if [ -n "$next" ] && printf '%s\n' ${tags[@]+"${tags[@]}"} | grep -qx "v$next"; then
  echo "error: tag v$next already exists" >&2
  exit 1
fi

# The release workflow commits the regenerated file after tagging, so that
# commit falls into the next release's range: drop it, it documents the
# changelog rather than the app.
AUTO_COMMIT_RE='^docs: update CHANGELOG for v'

# Newest first, to match the order of the sections, split into '### <day>'
# groups. The stable sort on the date guarantees a day gets a single heading
# even when author dates are out of order (rebases, cherry-picks).
log_range() {
  local tab
  tab="$(printf '\t')"
  git log --no-merges --date-order --date=short \
    --invert-grep --grep="$AUTO_COMMIT_RE" \
    --pretty=format:"%ad${tab}- %s ([\`%h\`]($base/commit/%H))" "$1" \
  | sort -t "$tab" -k1,1r -s \
  | awk -F"$tab" '
      $1 != day { if (day != "") printf "\n"; day = $1; printf "### %s\n\n", day }
      { print $2 }
    '
}

section() { # section <heading> <date> <range>
  local body
  body="$(log_range "$3")"
  [ -n "$body" ] || return 1   # nothing in this range: caller decides
  if [ -n "$2" ]; then
    printf '## [%s] - %s\n\n' "$1" "$2"
  else
    printf '## [%s]\n\n' "$1"
  fi
  printf '%s\n\n' "$body"
}

out="$(mktemp)"
body="$(mktemp)"
trap 'rm -f "$out" "$body"' EXIT

latest="${tags[0]:-}"
{
  if [ -n "$next" ]; then
    printf '## [Unreleased]\n\n'
    if ! section "$next" "$(date +%F)" "${latest:+$latest..}HEAD"; then
      echo "error: no commits since ${latest:-the start of the history}: nothing to release as $next" >&2
      exit 1
    fi
  else
    section "Unreleased" "" "${latest:+$latest..}HEAD" || printf '## [Unreleased]\n\n'
  fi

  # A tag pointing at an already-tagged commit has an empty range: skip it
  # rather than emit a section the release renderer would reject as empty.
  for i in "${!tags[@]}"; do
    tag="${tags[$i]}"
    prev="${tags[$((i + 1))]:-}"
    section "${tag#v}" "$(git log -1 --format=%ad --date=short "$tag")" \
      "${prev:+$prev..}$tag" || true
  done
} > "$body"

# Table of contents, built from the sections that made it into the file so it
# can't link to one that was skipped. The anchors reproduce how GitHub slugifies
# a heading: lowercase, drop everything but letters, digits, spaces, - and _,
# then spaces to hyphens ('## [2.0.3] - 2026-09-03' -> '#203---2026-09-03').
toc() {
  awk '
    function slug(s,   t) {
      t = tolower(s)
      gsub(/[^a-z0-9 _-]/, "", t)
      gsub(/ /, "-", t)
      return t
    }
    function label(h,   a, b) {
      a = index(h, "["); b = index(h, "]")
      return substr(h, a + 1, b - a - 1)
    }
    function flush() {
      if (heading != "" && filled)
        printf "- [%s](#%s)\n", label(heading), slug(substr(heading, 4))
    }
    /^## / { flush(); heading = $0; filled = 0; next }
    /^- /  { filled = 1 }
    END    { flush() }
  ' "$1"
}

{
  cat <<'HEADER'
# Changelog

Tutte le modifiche a ROQuiz, un commit per riga, raggruppate per versione e
per giorno.

<!--
QUESTO FILE È GENERATO: non modificarlo a mano, le modifiche verrebbero perse
alla rigenerazione successiva. Per aggiornarlo:

  .github/scripts/generate-changelog.sh            # commit nuovi -> [Unreleased]
  .github/scripts/generate-changelog.sh X.Y.Z      # commit nuovi -> [X.Y.Z]

Di norma non serve: lo rigenera e lo committa il workflow di release, dopo aver
creato il tag. Vedere .github/RELEASING.md.

Dato che le voci sono i messaggi di commit, la leggibilità di questo file
dipende da quanto sono descrittivi: conviene curarli, o fare squash prima del
merge.
-->

HEADER

  printf '## Versioni\n\n'
  toc "$body"
  printf '\n'

  cat "$body"

  # Link definitions, in the same order as the sections above.
  if [ -n "$next" ]; then
    printf '[Unreleased]: %s/compare/v%s...HEAD\n' "$base" "$next"
    printf '[%s]: %s/compare/%s...v%s\n' "$next" "$base" "${latest:-}" "$next"
  elif [ -n "$latest" ]; then
    printf '[Unreleased]: %s/compare/%s...HEAD\n' "$base" "$latest"
  fi

  for i in "${!tags[@]}"; do
    tag="${tags[$i]}"
    prev="${tags[$((i + 1))]:-}"
    if [ -n "$prev" ]; then
      printf '[%s]: %s/compare/%s...%s\n' "${tag#v}" "$base" "$prev" "$tag"
    else
      printf '[%s]: %s/releases/tag/%s\n' "${tag#v}" "$base" "$tag"
    fi
  done
} > "$out"

mv "$out" CHANGELOG.md
trap - EXIT
echo "CHANGELOG.md regenerated${next:+ with a [$next] section}."
