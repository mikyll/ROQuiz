#!/usr/bin/env bash
#
# Regenerate CHANGELOG.md from the git history: one line per commit, newest
# first, grouped by tag.
#
#   .github/scripts/generate-changelog.sh [next-version]
#
# Without arguments the commits made after the latest tag land under
# '## [Unreleased]'. With <next-version> they land in a new '## [<version>]'
# section instead: run it that way right before dispatching the release
# workflow, which reads that section to build the release page.
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

# Newest first, to match the order of the sections. Swap --date-order for
# --reverse to read a release bottom-up instead.
log_range() {
  git log --no-merges --date-order \
    --pretty=format:"- %s ([\`%h\`]($base/commit/%H))" "$1"
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
trap 'rm -f "$out"' EXIT

{
  cat <<'HEADER'
# Changelog

Tutte le modifiche a ROQuiz, un commit per riga, raggruppate per versione.

<!--
QUESTO FILE È GENERATO: non modificarlo a mano, le modifiche verrebbero perse
alla rigenerazione successiva. Per aggiornarlo:

  .github/scripts/generate-changelog.sh            # commit nuovi -> [Unreleased]
  .github/scripts/generate-changelog.sh 2.0.3      # commit nuovi -> [2.0.3]

Prima di lanciare il workflow di release, rigenerarlo con la versione che si sta
per rilasciare e committarlo: il workflow legge da qui il corpo della pagina
della release (.github/scripts/render-release-notes.sh) e si ferma subito se la
sezione manca.

Dato che le voci sono i messaggi di commit, la leggibilità di questo file
dipende da quanto sono descrittivi: conviene curarli, o fare squash prima del
merge.
-->

HEADER

  latest="${tags[0]:-}"
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
