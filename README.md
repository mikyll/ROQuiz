<div align="center">

  [![Downloads][downloads-shield]][downloads-url]
  [![Domande][domande-shield]][domande-url]
  [![Validazione Domande][validazione-shield]][validazione-url]
  [![Stargazers][stars-shield]][stars-url]
  [![Contributors][contributors-shield]][contributors-url]
  [![MIT License][license-shield]][license-url]
  [![Issues][issues-shield]][issues-url]
  <br />
  [![java][java-shield]][java-url]
  [![dart][dart-shield]][dart-url]
  [![flutter][flutter-shield]][flutter-url]
  
  <h1> ROQuiz</h1>
  <h3> Applicazione multipiattaforma per esercitarsi con i quiz del corso <a href="https://www.unibo.it/it/didattica/insegnamenti/insegnamento/2022/467997">Ricerca Operativa M</a>.</h3>
  
  L'app permette di <b>simulare dei quiz d'esame</b>: vengono pescate, in modo casuale, delle domande a risposta multipla a cui l'utente deve rispondere entro un tempo limite, definito da un timer.<br/>
  <b>Pool corrente</b>: <i><span id="domande">115</span></i> domande differenti (ultima modifica: <i><span id="ultima_modifica">2025-06-30</span></i>).

  [**Download**](https://github.com/mikyll/ROQuiz/releases/latest)
  ·
  [Spiegazione Domande](./Domande%20RO%20con%20spiegazione.pdf)
  ·
  [Feature Request | Bug Report](https://github.com/mikyll/ROQuiz/issues/new/choose)
</div>

## Demo

### Mobile

<table style="border: none">
  <tr align="center">
    <td><img width=50% src="./gfx/[GIF] Mobile_Quiz.gif" alt="DemoMobileGIF"/></td>
    <td><img width=50% src="./gfx/[GIF] Mobile_TopicsQuestionList.gif" alt="TopicsAndQuestionListGIF"/></td>
    <td><img width=50% src="./gfx/[GIF] Mobile_Settings.gif" alt="SettingsMobileGIF"/></td>
  </tr>
  <tr align="center">
    <td>Demo quiz</td>
    <td>Argomenti e lista domande</td>
    <td>Impostazioni</td>
  </tr>
</table>

### Desktop

<table style="border: none">
  <tr align="center">
    <td><img src="./gfx/[GIF] Desktop_QuizEnding.gif" alt="TimeoutGIF"/></td>
    <td><img src="./gfx/[GIF] Desktop_PlayingAround.gif" alt="PlayingAroundGIF"/></td>
  </tr>
  <tr align="center">
    <td>Tempo scaduto</td>
    <td>Demo app</td>
  </tr>
</table>

#### Java (Obsoleta)

<details>
  <summary>Versione Java funzionante ma non più supportata.</summary>
  <br/>
  
  <table style="border: none">
    <tr align="center">
      <td><img src="./gfx/[GIF] DesktopOld_EndQuiz.gif" alt="EndQuizGIF"/></td>
      <td><img src="./gfx/[GIF] DesktopOld_Timeout.gif" alt="TimeoutGIF"/></td>
    </tr>
    <tr align="center">
      <td>Terminazione quiz</td>
      <td>Tempo scaduto</td>
    </tr>
  </table>
</details>

### Web

Per ora è accessibile al mio sito web: [mikyll.github.io/projects/roquiz/play](https://mikyll.github.io/projects/roquiz/play/)

## Disclaimer

L'obiettivo dell'applicazione è esercitarsi coi quiz dopo aver studiato la teoria (molto meglio se dal libro, in quanto è completo ed esaustivo). <b>Non mi assumo responsabilità di alcun tipo nel caso di errori nelle domande o nelle risposte, né tantomento nel caso di bocciature potenti</b>. Fatene un buon uso e buona fortuna con l'esame <3

## Download

Scaricare l'[ultima release](https://github.com/mikyll/ROQuiz/releases/latest), per il proprio dispositivo (desktop/mobile).

## Formattazione domande

Le domande sono caricate da un <a href="./Domande.txt">file di testo (.txt)</a> che ha il seguente formato:
* (opzionale) Argomenti:
  - la riga di un argomento inizia col carattere speciale '@', seguito dal titolo dell'argomento (es: Complessità). Ogni riga di argomento è seguita dalle domande relative a quell'argomento, fino all'argomento successivo. Alla fine della riga dell'argomento possono essere usati caratteri non alfabetici (ad esempio '=') per separare visivamente le domande di argomenti differenti (tali caratteri verranno ignorati).
* Domande:
  - una riga per la domanda;
  - 5 righe per le risposte (la riga inizia con una lettera maiuscola, seguita da un punto e dalla risposta);
  - una riga per la risposta corretta (una lettera da A a E);
  - una riga vuota se non è l'ultima domanda (questa riga separa la domanda da quella successiva, o dall'argomento successivo).

**NB**: non è importante la lettera con cui iniziano le risposte, basta che siano in ordine, altrimenti la risposta giusta e la lettera non corrispondono.

esempio (tre domande di due argomenti diversi nel file Domande.txt):
<pre>
@Programmazione Matematica =============================================================================
Dato un insieme F, un intorno è
A. L'insieme di tutti i sottoinsiemi di F
B. L'insieme dei punti di F a distanza minore di epsilon da un punto x di F
C. Una funzione N: F -> 2^F
D. Una combinazione convessa di due punti x e y di F
E. Nessuna di queste
C

@Dualità ===============================================================================================
Se un problema di programmazione lineare (primale) ha soluzione ottima finita, allora:
A. Il suo duale non è detto che abbia soluzione ottima finita.
B. Anche il suo duale ha soluzione ottima finita e i valori delle soluzioni coincidono.
C. Anche il duale ha soluzione ottima finita, ma non è detto che i valori delle soluzioni coincidano.
D. Anche il duale ha soluzione ottima finita, ma i valori delle due soluzioni non coincidono.
E. Nessuna di queste
B

Quale tra queste affermazioni è falsa rispetto ad una corrispondenza primale-duale?
A. Ai costi corrispondono condizioni su variabili e viceversa.
B. I vincoli sono dati dalle righe di A per il primale, dalle colonne di A per il duale.
C. Ai costi corrispondono i termini noti e viceversa.
D. Ad un vincolo corrisponde una condizione su una variabile e viceversa.
E. Nessuna di queste.
A
</pre>

## Spiegazione Domande

[Questo documento](./Domande%20RO%20con%20spiegazione.pdf), a cura di [Lorenzo di Palma](https://github.com/lollofred) e [Filippo Veronesi](https://github.com/filippoveronesi), contiene la spiegazione alla maggior parte delle domande presenti nel quiz.

## Come Contribuire

Vedi [CONTRIBUTING.md](./CONTRIBUTING.md).

### Contributors Attuali

<!-- readme: contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/mikyll">
                    <img src="https://avatars.githubusercontent.com/u/56556806?v=4" width="100;" alt="mikyll"/>
                    <br />
                    <sub><b>mikyll</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/jchergu">
                    <img src="https://avatars.githubusercontent.com/u/96496259?v=4" width="100;" alt="jchergu"/>
                    <br />
                    <sub><b>jchergu</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/filippoveronesi">
                    <img src="https://avatars.githubusercontent.com/u/61983672?v=4" width="100;" alt="filippoveronesi"/>
                    <br />
                    <sub><b>filippoveronesi</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/TryKatChup">
                    <img src="https://avatars.githubusercontent.com/u/39459803?v=4" width="100;" alt="TryKatChup"/>
                    <br />
                    <sub><b>TryKatChup</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/Emanuele8">
                    <img src="https://avatars.githubusercontent.com/u/22657821?v=4" width="100;" alt="Emanuele8"/>
                    <br />
                    <sub><b>Emanuele8</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/Federicoand98">
                    <img src="https://avatars.githubusercontent.com/u/40764404?v=4" width="100;" alt="Federicoand98"/>
                    <br />
                    <sub><b>Federicoand98</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/lollofred">
                    <img src="https://avatars.githubusercontent.com/u/73138694?v=4" width="100;" alt="lollofred"/>
                    <br />
                    <sub><b>lollofred</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/RedDuality">
                    <img src="https://avatars.githubusercontent.com/u/61973885?v=4" width="100;" alt="RedDuality"/>
                    <br />
                    <sub><b>RedDuality</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: contributors -end -->

## Funzionalità

<details>
  <summary>Features dell'app e sviluppi futuri.</summary>
  <br/>
  
  <table>
    <tr align="center">
      <td><b>Feature</b></td>
      <td width="15%">🖥️|📱</td>
    </tr>
    <tr align="center">
      <td>Visualizzazione lista domande in-app</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Possibilità di modificare il file domande</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Scelta degli argomenti</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Visualizzazione lista domande (totale, pool, per argomento)</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Strumento di ricerca delle domande per keystring</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazioni persistenti</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: tema scuro</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: toggle controllo aggiornamenti app</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: toggle controllo nuove domande</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: modifica del file domande (da dentro l'applicazione)</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: caricamento file domande esterno</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: modifica del numero di domande del quiz</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: modifica del timer del quiz</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: toggle mescolamento delle risposte</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: toggle alert di conferma</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: toggle tema scuro</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Template per pubblicare una issue</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Impostazione: modifica del file domande (<a href="https://api.flutter.dev/flutter/widgets/EditableText-class.html">reference</a>)</td>
      <td>✔️</td>
    </tr>
    <tr align="center">
      <td>Modifica domande: scroll automatico alla riga dell'errore</td>
      <td>❌</td>
    </tr>
    <tr align="center">
      <td>Controllo domande duplicate</td>
      <td>❌</td>
    </tr>
    <tr align="center">
      <td>Unit/Function test</td>
      <td>❌</td>
    </tr>
    <tr align="center">
      <td>Pipeline CI/CD per build e deploy</td>
      <td>❌</td>
    </tr>
    <tr align="center">
      <td>Versione web ospitata su GitHub pages</td>
      <td>❌</td>
    </tr>
  </table>
</details>

## Built With

- IDE: **VSCode** v1.81.1
- Framework: **Flutter** v3.13.1

<!--
### Desktop (Old)

Per l'implementazione dell'app desktop ho utilizzato Java 11 e JavaFX 11, come IDE Eclipse (versione 2020-03 (4.15.0)), e SceneBuilder per la creazione della grafica (file FXML). Vedere i passi seguiti per il [setup del progetto](./Project%20Setup.md).

versione Java: JavaSE-11 (jdk-11.0.11)<br/>
versione JavaFX: JavaFX 11 (javafx-sdk-11.0.2)
-->

## Build

### Setup Flutter e Run del Progetto

1. Scaricare l'SDK Flutter dal sito web [docs.flutter.dev](https://docs.flutter.dev/get-started/install).
2. Assicurarsi di aver inserito la directory `bin/` alla variabile d'ambiente `PATH`.
3. Aprire un terminale e lanciare `flutter doctor`.<br/>
   Questo comando indica se ci sono problemi con l'SDK e fornisce informazioni sulle dipendenze necessarie per il suo funzionamento.
4. Lanciare il comando `flutter run` per avviare l'applicazione. Flutter chiederà di selezionare il dispositivo (es. Chrome, Android). Si può specificare direttamente il device id con l'opzione `-d`, ad esempio per la versione web con Microsoft Edge:
   ```
   flutter run -d edge
   ```

### Compilazione Release

Il progetto dell'applicazione flutter si trova nella directory [`app-mobile/flutter_application`](./app-mobile/flutter_application).
Per compilarlo, lanciare uno dei comandi seguenti, in base all'output desiderato:
- Android: `flutter build apk --split-per-abi`;
- Windows: `flutter build windows`;
- Linux: `flutter build linux`;
- Web: `flutter build chrome`, `flutter build edge`.

## Riferimenti

<details>
  <summary>Link e risorse a cui ho fatto riferimento durante lo sviluppo dell'app.</summary><br/>

  - [Ciclo di vita](https://docs.oracle.com/javase/8/javafx/api/javafx/application/Application.html) della classe Application
  - Guida a classe Timeline usata per realizzare il countdown: [Timers in JavaFX and ReactFX](https://tomasmikula.github.io/blog/2014/06/04/timers-in-javafx-and-reactfx.html)
  - Lavorare coi moduli Java: [Java 9 Modules in Eclipse](https://blogs.oracle.com/java/post/how-to-develop-modules-with-eclipse-ide)
  - Creare jre custom con JavaFX (jlink): [Custom jre with JavaFX 11](https://stackoverflow.com/questions/52966195/custom-jre-with-javafx-11) e [How to use jlink to create a Java image with javafx modules](https://github.com/javafxports/openjdk-jfx/issues/238)
  - JavaFX ottenere HostService senza riferimento alla classe Application (Main extends Application): [Open a link in a browser without reference to Application](https://stackoverflow.com/questions/33094981/javafx-8-open-a-link-in-a-browser-without-reference-to-application)
  - Soluzione per eccezione SSL handshake: [SSLHandshakeException: Received fatal alert: handshake_failure](https://stackoverflow.com/questions/54770538/received-fatal-alert-handshake-failure-in-jlinked-jre)
  - Gestione dei moduli (ad esempio Gson): [InaccessibleObjectException ("Unable to make {member} accessible: module {A} does not 'opens {package}' to {B}")](https://stackoverflow.com/questions/41265266/how-to-solve-inaccessibleobjectexception-unable-to-make-member-accessible-m)
  - [JavaFX CSS Docs](https://docs.oracle.com/javafx/2/api/javafx/scene/doc-files/cssref.html)
  - [Fix puntini bianchi](https://stackoverflow.com/questions/44169273/javafx-unwanted-white-corner-textarea) negli angoli della TextArea, usando il tema scuro
  - [StackOverflow GitHub latest version](https://stackoverflow.com/questions/34745526/java-get-latest-github-release)
  - [Richieste HTTP con java.net](https://www.baeldung.com/java-http-response-body-as-string)
  - [Using jlink to Build Java Runtimes for non-Modular Applications](https://medium.com/azulsystems/using-jlink-to-build-java-runtimes-for-non-modular-applications-9568c5e70ef4)
  - [Download asset Flutter](https://pub.dev/packages/download_assets)
  - [LongPress Widget](https://stackoverflow.com/questions/52128572/flutter-execute-method-so-long-the-button-pressed)
  - [Flutter CI/CD using GitHub Actions](https://blog.logrocket.com/flutter-ci-cd-using-github-actions/)
  - Build Flutter Installers:
    - [MacOS](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285)
    - [Windows](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-for-open-source-indie-0b468d5e9e70)
    - [Linux](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-3-linux-24ef8d30a5b4)

</details>

<div align="center">
  
  <br/><br/>
  <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
  
[![LinkedIn][linkedin-shield]][linkedin-url]
[![GitHub followers][github-shield]][github-url]

</div>

[downloads-shield]: https://img.shields.io/github/downloads/mikyll/ROQuiz/total
[downloads-url]: https://github.com/mikyll/ROQuiz/releases/latest
[contributors-shield]: https://img.shields.io/github/contributors/mikyll/ROQuiz
[contributors-url]: https://github.com/mikyll/ROQuiz/graphs/contributors
[domande-shield]: https://img.shields.io/static/v1?label=domande&message=115&color=green
[domande-url]: https://github.com/mikyll/ROQuiz/blob/main/Domande.txt
[validazione-shield]: https://github.com/mikyll/ROQuiz/actions/workflows/check_file_domande.yml/badge.svg
[validazione-url]: https://github.com/mikyll/ROQuiz/actions/workflows/check_file_domande.yml
[forks-shield]: https://img.shields.io/github/forks/mikyll/ROQuiz
[forks-url]: https://github.com/mikyll/ROQuiz/network/members
[repo-size-shield]: https://img.shields.io/github/repo-size/mikyll/ROQuiz
[repo-size-url]: https://img.shields.io/github/repo-size/mikyll/ROQuiz
[total-lines-shield]: https://img.shields.io/tokei/lines/github/mikyll/ROQuiz
[total-lines-url]: https://img.shields.io/tokei/lines/github/mikyll/ROQuiz
[pull-request-shield]: https://img.shields.io/github/issues-pr/mikyll/ROQuiz
[pull-request-url]: https://img.shields.io/github/issues-pr/mikyll/ROQuiz
[stars-shield]: https://img.shields.io/github/stars/mikyll/ROQuiz?style=flat
[stars-url]: https://github.com/mikyll/ROQuiz/stargazers
[issues-shield]: https://img.shields.io/github/issues/mikyll/ROQuiz
[issues-url]: https://github.com/mikyll/ROQuiz/issues
[license-shield]: https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg
[license-url]: https://creativecommons.org/licenses/by-nc-sa/4.0/
[java-shield]: https://custom-icon-badges.herokuapp.com/badge/Java-ED8B00?logo=java&logoColor=white
[java-url]: https://www.java.com
[dart-shield]: https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white
[dart-url]: https://dart.dev/
[flutter-shield]: https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white
[flutter-url]: https://flutter.dev/
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?logo=linkedin&colorB=0077B5
[linkedin-url]: https://www.linkedin.com/in/michele-righi/?locale=it_IT
[github-shield]: https://img.shields.io/github/followers/mikyll.svg?style=social&label=Follow
[github-url]: https://github.com/mikyll
