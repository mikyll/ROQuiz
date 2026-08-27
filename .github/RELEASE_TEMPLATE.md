<!--
Template del corpo della pagina di release.

Segnaposto da sostituire (tutti, nessuno escluso):
  {{REPO}}          owner/repo, es. mikyll/ROQuiz
  {{VERSION}}       versione senza la v iniziale, es. 2.0.0
  {{PREV_VERSION}}  versione della release precedente, es. 1.11.5
  {{CHANGELOG}}     sezione di CHANGELOG.md relativa a {{VERSION}}

Gli asset elencati sotto sono quelli prodotti da .github/workflows/release.yml.
Se cambiano i nomi dei file, questo template va aggiornato di conseguenza.
-->

![Downloads v{{VERSION}}](https://img.shields.io/github/downloads/{{REPO}}/v{{VERSION}}/total)

## Novità

{{CHANGELOG}}

Elenco completo dei commit: [`v{{PREV_VERSION}}...v{{VERSION}}`](https://github.com/{{REPO}}/compare/v{{PREV_VERSION}}...v{{VERSION}})

## Download

| Piattaforma | File |
| --- | --- |
| 🪟 Windows x64 | [`roquiz_v{{VERSION}}_windows-x64.zip`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/roquiz_v{{VERSION}}_windows-x64.zip) |
| 🐧 Linux x64 | [`roquiz_v{{VERSION}}_linux-x64.tar.gz`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/roquiz_v{{VERSION}}_linux-x64.tar.gz) |
| 🤖 Android arm64-v8a | [`roquiz_v{{VERSION}}_arm64-v8a.apk`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/roquiz_v{{VERSION}}_arm64-v8a.apk) |
| 🤖 Android armeabi-v7a | [`roquiz_v{{VERSION}}_armeabi-v7a.apk`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/roquiz_v{{VERSION}}_armeabi-v7a.apk) |
| 🤖 Android x86_64 | [`roquiz_v{{VERSION}}_x86_64.apk`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/roquiz_v{{VERSION}}_x86_64.apk) |

> [!TIP]
> Non sai quale APK scaricare? Praticamente tutti i telefoni Android in uso oggi
> sono **arm64-v8a**. `armeabi-v7a` serve solo a dispositivi molto vecchi,
> `x86_64` agli emulatori.

### Installazione

- **Windows**: estrarre lo zip e lanciare `roquiz.exe`.
- **Linux**: estrarre l'archivio (`tar -xzf roquiz_v{{VERSION}}_linux-x64.tar.gz`) e lanciare `./roquiz`.
- **Android**: installare l'APK; se richiesto, autorizzare l'installazione da origini sconosciute.

## Web

Nessuna installazione necessaria: [mikyll.github.io/ROQuiz/](https://mikyll.github.io/ROQuiz/)

## Verifica dei file

Gli hash SHA-256 di tutti gli asset sono in [`SHA256SUMS.txt`](https://github.com/{{REPO}}/releases/download/v{{VERSION}}/SHA256SUMS.txt).

```bash
sha256sum -c SHA256SUMS.txt --ignore-missing
```

## Note

La versione Java non è più supportata: l'[ultima release Java](https://github.com/{{REPO}}/releases/tag/v1.5) resta scaricabile e continua a controllare e scaricare le domande aggiornate, ma non riceverà nuove funzionalità.
