# Changelog

Tutte le modifiche a ROQuiz, un commit per riga, raggruppate per versione e
per giorno.

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

## Versioni

- [2.0.3](#203---2026-09-12)
- [2.0.2](#202---2026-08-27)
- [2.0.1](#201---2026-08-26)
- [2.0.0](#200---2026-07-11)
- [1.0.0](#100---2026-07-11)

## [Unreleased]

## [2.0.3] - 2026-09-12

### 2026-09-12

- docs: clarify that the key password equals the keystore one ([`63a0111`](https://github.com/mikyll/ROQuiz-test/commit/63a01118d24f7c1c1beeb49d4fd82962e3d117b7))

### 2026-09-09

- docs: group changelog commits by day ([`fbdb4a4`](https://github.com/mikyll/ROQuiz-test/commit/fbdb4a427283e85be13a53beebbcf08beb394bb9))
- docs: link the changelog sections from a table of contents ([`62c96a7`](https://github.com/mikyll/ROQuiz-test/commit/62c96a7537153d67354c703994909ae1797841f7))
- docs: generate the keystore outside the repository ([`fc4a9d1`](https://github.com/mikyll/ROQuiz-test/commit/fc4a9d1c55916b696ffc4a70740d2a55b43ed486))

### 2026-09-04

- chore: never track signing keys anywhere in the repo ([`7159ea5`](https://github.com/mikyll/ROQuiz-test/commit/7159ea514a82e6fba519ec3373f225c4f6424b44))
- docs: document the release procedure ([`1432a00`](https://github.com/mikyll/ROQuiz-test/commit/1432a000292e36029bd159bcac1625924f80ba6e))
- docs: generate CHANGELOG.md from the commit history ([`4409b63`](https://github.com/mikyll/ROQuiz-test/commit/4409b63b3aaf166b695e4a49456e69e7116d56f0))
- ci: make Android releases installable over each other ([`c3fb82f`](https://github.com/mikyll/ROQuiz-test/commit/c3fb82fd2c7758bd6ace425ce850b6c0afce8848))

## [2.0.2] - 2026-08-27

### 2026-08-27

- docs: add the 2.0.2 changelog section ([`83fb4e3`](https://github.com/mikyll/ROQuiz-test/commit/83fb4e34c39413f3c262ae2e06c16423387d5094))
- ci: run the test suite only after the version check passes ([`4293eac`](https://github.com/mikyll/ROQuiz-test/commit/4293eac515d66c1997c8f465edfe3ed574e00d31))
- ci: build the release body from CHANGELOG.md ([`329a50b`](https://github.com/mikyll/ROQuiz-test/commit/329a50bbbf34d9c1a952d43357274d52c7dd5a9b))
- docs: add a CHANGELOG in Keep a Changelog format ([`78355ad`](https://github.com/mikyll/ROQuiz-test/commit/78355ade0f32c20927472961bd412f9135ccd267))
- ci: gate releases on a pre-flight check and the test suite ([`acb01d5`](https://github.com/mikyll/ROQuiz-test/commit/acb01d572d3258c4ee786588ac1d15f5a5fa832f))
- test: align confirmation level expectations with the full default ([`5a7855c`](https://github.com/mikyll/ROQuiz-test/commit/5a7855ca791a50b406a9c83446fd840aed050ddd))

## [2.0.1] - 2026-08-26

### 2026-08-26

- ci: host a single app version on GitHub Pages ([`a52caa2`](https://github.com/mikyll/ROQuiz-test/commit/a52caa205020bf9c900adc8743198d244b2a8ec9))
- ci: derive web base-href from the repository name ([`62087fb`](https://github.com/mikyll/ROQuiz-test/commit/62087fb06b5a8618b16a5d31a242dc5e925f3bba))

## [2.0.0] - 2026-07-11

### 2026-07-11

- ci: host coexisting app versions on GitHub Pages ([`3e56bc7`](https://github.com/mikyll/ROQuiz-test/commit/3e56bc76d7e34db250c8a1b0f42ee4e533a032d2))
- ci: build and tag a specific commit in the release workflow ([`50eea34`](https://github.com/mikyll/ROQuiz-test/commit/50eea34026ba10e4ae15b01e43750ae4bd3edeb9))
- ci: rename release assets to roquiz_v<version>_<platform> ([`2090bcb`](https://github.com/mikyll/ROQuiz-test/commit/2090bcbec3b816656125bdd7af802a34317c1bca))

## [1.0.0] - 2026-07-11

### 2026-07-11

- ci: fix ([`045386b`](https://github.com/mikyll/ROQuiz-test/commit/045386b2daecc072a7b1ac6e3585bd2299491e6f))
- first commit ([`9a17ae9`](https://github.com/mikyll/ROQuiz-test/commit/9a17ae91f94e39512cb25f54cdb34cc6b5d0152b))

[Unreleased]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.3...HEAD
[2.0.3]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/mikyll/ROQuiz-test/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/mikyll/ROQuiz-test/releases/tag/v1.0.0
