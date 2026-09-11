# Come si rilascia

## Una tantum: la chiave di firma Android

Android rifiuta di installare una APK sopra un'altra firmata con una chiave
diversa. Senza i secret qui sotto Gradle ripiegherebbe su una debug keystore
usa-e-getta, diversa a ogni run, e nessun aggiornamento funzionerebbe: per
questo il workflow fallisce se i secret mancano.

1. Generare la keystore (una sola volta, in locale). Il percorso è assoluto e
   **fuori dal repo**: una chiave committata su un repo pubblico è bruciata per
   sempre. I parametri sono quelli che il Play Store pretende, così la stessa
   chiave resta valida se un domani si pubblica lì:

   ```sh
   mkdir -p ~/.keys
   keytool -genkeypair -v -keystore ~/.keys/roquiz-release.jks \
     -alias roquiz -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Farne un backup**: file e password nel password manager, più una copia
   offline. Se la chiave si perde non esiste recupero — si riparte da capo e
   tutti gli utenti devono disinstallare e reinstallare.

3. Aggiungere i secret del repository (Settings → Secrets and variables →
   Actions):

   | Secret | Valore |
   | --- | --- |
   | `ANDROID_KEYSTORE_BASE64` | `base64 -w0 ~/.keys/roquiz-release.jks` |
   | `ANDROID_KEYSTORE_PASSWORD` | password della keystore |
   | `ANDROID_KEY_ALIAS` | `roquiz` |
   | `ANDROID_KEY_PASSWORD` | la stessa password della keystore (vedi sotto) |

   Le keystore create da un JDK recente sono in formato PKCS12, che non prevede
   una password separata per la chiave: `keytool` scarta l'eventuale `-keypass`
   con un warning e la chiave si apre con la password della keystore. Gli ultimi
   due secret vanno quindi valorizzati uguali.

   Per non lasciare la chiave in chiaro nello scrollback del terminale conviene
   mandare il base64 dritto negli appunti:

   ```sh
   base64 -w0 ~/.keys/roquiz-release.jks | xclip -selection clipboard
   ```

Il `versionCode` non si tocca: il workflow lo deriva dalla versione
(`major*10000 + minor*100 + patch`, quindi `2.0.3` → `20003`), così cresce
sempre. Come conseguenza `minor` e `patch` devono restare sotto 100.

## A ogni release

```sh
git fetch --tags
.github/scripts/generate-changelog.sh 2.0.3   # la versione che stai per rilasciare
git add CHANGELOG.md && git commit -m "docs: changelog for 2.0.3"
git push
```

Poi Actions → **Release** → *Run workflow*, con `version` = `2.0.3` (senza la
`v`), `prerelease` = `auto`, `ref` vuoto.

Il job `check-version` fa da filtro in ~30 secondi: rifiuta le versioni
malformate, i tag già esistenti e i CHANGELOG senza la sezione della versione,
prima che parta qualsiasi build. Se passa, gira tutto il resto: test, quattro
build (Android, Linux, Windows, web), la release con le note generate da
`CHANGELOG.md` via `.github/RELEASE_TEMPLATE.md`, e il deploy su GitHub Pages.

## Verificare che l'aggiornamento funzioni

Vale la pena farlo dopo il primo rilascio firmato, e ogni volta che si tocca la
firma:

```sh
apksigner verify --print-certs roquiz_vX.Y.Z_universal.apk
```

Il fingerprint SHA-256 deve essere sempre lo stesso fra una release e l'altra.
La prova definitiva è installare una release sul telefono e installarci sopra
quella successiva senza disinstallare.
