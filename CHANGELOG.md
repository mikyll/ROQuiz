# Changelog

Tutte le modifiche rilevanti a ROQuiz sono documentate in questo file.

Il formato segue [Keep a Changelog](https://keepachangelog.com/it-IT/1.1.0/)
e il progetto aderisce al [Semantic Versioning](https://semver.org/lang/it/).

<!--
COME SI USA

Durante lo sviluppo le voci si aggiungono sotto `## [Unreleased]`. Al momento
del rilascio si rinomina quella intestazione in `## [X.Y.Z] - AAAA-MM-GG`, si
riapre un `## [Unreleased]` vuoto sopra, e si aggiorna la lista di link in
fondo al file.

Il workflow di release estrae da qui il corpo della pagina della release
(.github/scripts/render-release-notes.sh): una sezione mancante o vuota blocca
il rilascio. Prima di rilasciare, cancellare le sottosezioni rimaste vuote.

Sottosezioni disponibili, da usare solo quando servono e in quest'ordine:
  Aggiunto    nuove funzionalità
  Modificato  cambiamenti a funzionalità esistenti
  Deprecato   funzionalità che verranno rimosse
  Rimosso     funzionalità rimosse
  Corretto    bug fix
  Sicurezza   vulnerabilità

Esempio di sezione rilasciata:

  ## [2.0.0] - 2026-09-01

  ### Aggiunto

  - Editor delle domande integrato nell'app ([#42](https://github.com/mikyll/ROQuiz/pull/42)).

  ### Corretto

  - Le impostazioni non venivano salvate su Android 14 ([#57](https://github.com/mikyll/ROQuiz/issues/57)).

Le release precedenti alla 2.0.0 non sono riportate qui: le note stanno sulla
pagina Releases del repository.
-->

## [Unreleased]

## [2.0.2] - 2026-08-27

### Modificato

- Nessuna modifica all'applicazione: questa release serve a validare la nuova
  pipeline di rilascio (build Windows, note generate da questo file).

[Unreleased]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.2...HEAD
[2.0.2]: https://github.com/mikyll/ROQuiz-test/compare/v2.0.1...v2.0.2
