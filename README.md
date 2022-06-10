<div align="center">

[![Downloads][downloads-shield]][downloads-url]
[![Domande][domande-shield]][domande-url]
[![Validazione Domande][validazione-shield]][validazione-url]
[![Stargazers][stars-shield]][stars-url]
[![Contributors][contributors-shield]][contributors-url]
[![MIT License][license-shield]][license-url]
[![Issues][issues-shield]][issues-url]
<br/>
[![java][java-shield]][java-url]
[![dart][dart-shield]][dart-url]
[![flutter][flutter-shield]][flutter-url]

<h1> ROQuiz</h1>
<h3> Applicazione multipiattaforma per esercitarsi con i quiz del corso Ricerca Operativa M.</h3>
<hr class="rounded">
</div>

### Versioni Disponibili
- Desktop (Windows, Linux e MacOS)
- Mobile (Android)

### Funzionalità
- L'app **simula un quiz d'esame**, pescando in modo casuale delle domande a risposta multipla a cui l'utente deve rispondere entro il tempo limite definito da un timer.
- Pool di <span id="domande">87</span> domande differenti, divise per argomento (elenco aggiornato al _25 gennaio 2022_).
- Possibilità di scelta di argomenti specifici per le domande da includere nel quiz.
- Possibilità di personalizzare le impostazioni dell'app in modo persistente:
  - Scelta di un numero specifico di domande (default: 16, selezionate casualmente).
  - Modifica del tempo a disposizione per il quiz (default: 18 minuti).
  - Controllo all'avvio dell'app se nella repository sono presenti nuove domande.
- Possibilità di inserimento di domande personalizzate (modificando il file Domande.txt).

### Demo
#### Desktop
<table style="border: none">
  <tr>
    <td width="49.9%"><img src="./gfx/[GIF] DesktopEndQuiz.gif" alt="EndQuizGIF"/></td>
    <td width="49.9%"><img src="./gfx/[GIF] DesktopTimeout.gif" alt="TimeoutGIF"/></td>
  </tr>
  <tr>
    <td align="center">Terminazione quiz</td>
    <td align="center">Tempo scaduto</td>
  </tr>
</table>

#### Mobile
<table style="border: none">
  <tr>
    <td align="center"><img width=50% src="./gfx/[GIF] MobileInstall.gif" alt="InstallMobileGIF"/></td>
    <td align="center"><img width=50% src="./gfx/[GIF] MobileUsage.gif" alt="MobileUsageGIF"/></td>
  </tr>
  <tr>
    <td align="center">Installazione versione mobile</td>
    <td align="center">Terminazione quiz</td>
  </tr>
</table>

### Esecuzione
#### Versione Desktop (Windows e Linux)
1. Scaricare l'[ultima release](https://github.com/mikyll/ROQuiz/releases/latest) ([Windows](https://github.com/mikyll/ROQuiz/releases/download/v1.4/ROQuizDeployWindows.zip), [Linux](https://github.com/mikyll/ROQuiz/releases/download/v1.4/ROQuizDeployLinux.tar.gz) o [MacOS](https://github.com/mikyll/ROQuiz/releases/download/v1.4/ROQuizDeployMac.tar.gz)) ed estrarre il contenuto.
2. Eseguire Launcher con doppioclick.

#### Versione Mobile (Android)
1. Scaricare l'[apk](https://github.com/mikyll/ROQuiz/releases/download/v1.4/roquiz-mobile.apk).
2. Selezionare ```INSTALLA``` e ```INSTALLA COMUNQUE```.

### Formattazione domande
Le domande sono caricate da un file "<a href="./Domande.txt">Domande.txt</a>" che ha il seguente formato:
* (opzionale) Argomenti:
  - la riga di un argomento inizia col carattere speciale '@', seguito dal nome dell'argomento. Ogni riga di argomento è seguita dalle domande relative a quell'argomento, fino all'argomento successivo. Alla fine della riga dell'argomento possono essere usati caratteri non alfabetici (ad esempio '=') per separare visivamente le domande di argomenti differenti (tali caratteri verranno ignorati).
* Domande: 
  - una riga per la domanda;
  - 5 righe per le risposte (la riga inizia con una lettera maiuscola, seguita da un punto e dalla risposta);
  - una riga per la risposta corretta (una lettera da A a E);
  - una riga vuota se non è l'ultima domanda (questa riga separa la domanda da quella successiva, o dall'argomento successivo).

NB: non è importante la lettera con cui iniziano le risposte, basta che siano in ordine, altrimenti la risposta giusta e la lettera non corrispondono.

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

### Contribuire
Aggiunta domande o feature al progetto:
1. Fare una **fork** della repository.
2. Clonare la repository in locale.
3. (Opzionale) Creare un nuovo branch.
4. Aggiungere le modifiche:
  * Per aggiungere nuove domande: modificare il file 'Domande.txt', inserendo le nuove domande sotto gli argomenti relativi. NB: in caso non si sappia sotto quale argomento inserire una somanda, scriverlo successivamente in un commento nella pull request.<br/>
  * Per aggiungere delle feature, basta implementarle e integrarle col resto dell'applicazione (in caso di dubbi o domande sul funzionamento di alcune parti di codice, basta aprire un issue e cercherò di rispondere il prima possibile).
5. Fare commit e push.
6. Creare una **pull request** aggiungendo informazioni se necessario.

Proposta feature:
1. Aprire un issue spiegando in cosa consiste la feature da aggiungere.
2. Possibilmente aggiungervi la label "enhancement".

### Roadmap
Features da aggiungere e sviluppi futuri:
- [x] aggiungere la scelta degli argomenti
- [x] impostazioni persistenti
- [x] download domande aggiornate
- [x] impostazione per abilitare/disabilitare il controllo delle domande aggiornate
- [x] deploy su MacOS
- [x] aggiornamento automatico del Readme quando vengono aggiunte nuove domande (GitHub actions)
- [ ] aggiungere bottone per visualizzare l'elenco delle domande, dagli argomenti
- [ ] fare il porting su mobile
  - [x] [Android](https://github.com/mikyll/ROQuiz/releases/tag/v1.3-mobile_beta)
  - [ ] iOS
- [ ] aggiungere test domande duplicate
- [ ] verifica aggiornamenti app
- [ ] creare tool per inserire domande nuove (che sfrutta il test per le domande duplicate)
- [ ] desktop: aggiungere impostazione dark mode ([riferimento utile](https://stackoverflow.com/questions/49159286/make-a-dark-mode-with-javafx))
- [x] mobile: fare refactor e sistemare le classi (usare classe Quiz)
- [x] mobile: aggiungere scelta argomenti
- [ ] mobile: aggiungere possibilità di caricare un file domande personalizzato
- [ ] cambiare il controllo per le domande nuove e farlo in base alla data di modifica o ad un numero di versione
- [ ] aggiungere bottone di reset e reload negli argomenti

### Built With
#### Desktop
Per l'implementazione dell'app desktop ho utilizzato Java 11 e JavaFX 11, come IDE Eclipse (versione 2020-03 (4.15.0)), e SceneBuilder per la creazione della grafica (file FXML). Vedere i passi seguiti per il [setup del progetto](./Project%20Setup.md).

versione Java: JavaSE-11 (jdk-11.0.11)<br/>
versione JavaFX: JavaFX 11 (javafx-sdk-11.0.2)

#### Mobile
Per l'implementazione dell'app mobile ho utilizzato Flutter, come IDE Visual Studio Code (versione 1.64.2).

versione Flutter: 2.8.1<br/>
versione Dart: 2.15.1

### Disclaimer
L'obiettivo dell'applicazione è esercitarsi coi quiz dopo aver studiato la teoria (molto meglio se dal libro, in quanto è completo ed esaustivo). <b>Non mi assumo responsabilità di alcun tipo nel caso di errori nelle domande o nelle risposte, né tantomento nel caso di bocciature potenti</b>. Fatene un buon uso e buona fortuna con l'esame <3

### Riferimenti
* [Ciclo di vita](https://docs.oracle.com/javase/8/javafx/api/javafx/application/Application.html) della classe Application
* Guida a classe Timeline usata per realizzare il countdown: [Timers in JavaFX and ReactFX](https://tomasmikula.github.io/blog/2014/06/04/timers-in-javafx-and-reactfx.html)
* Lavorare coi moduli Java: [Java 9 Modules in Eclipse](https://blogs.oracle.com/java/post/how-to-develop-modules-with-eclipse-ide)
* Creare jre custom con JavaFX (jlink): [Custom jre with JavaFX 11](https://stackoverflow.com/questions/52966195/custom-jre-with-javafx-11) e [How to use jlink to create a Java image with javafx modules](https://github.com/javafxports/openjdk-jfx/issues/238)
* JavaFX ottenere HostService senza riferimento alla classe Application (Main extends Application): [Open a link in a browser without reference to Application](https://stackoverflow.com/questions/33094981/javafx-8-open-a-link-in-a-browser-without-reference-to-application)
* Soluzione per eccezione SSL handshake: [SSLHandshakeException: Received fatal alert: handshake_failure](https://stackoverflow.com/questions/54770538/received-fatal-alert-handshake-failure-in-jlinked-jre)
* Gestione dei moduli (ad esempio Gson): [InaccessibleObjectException ("Unable to make {member} accessible: module {A} does not 'opens {package}' to {B}")](https://stackoverflow.com/questions/41265266/how-to-solve-inaccessibleobjectexception-unable-to-make-member-accessible-m)
<!--* [Doc LaTeX con definizioni per la teoria](https://github.com/kmfrick/College_Notes/tree/main/RO-M), realizzato da [kmfrick](https://github.com/kmfrick), Corinna Marchili, Sofia Montebugnoli-->

<div align="center">
  
[![LinkedIn][linkedin-shield]][linkedin-url]
[![GitHub followers][github-shield]][github-url]

</div>

[downloads-shield]: https://img.shields.io/github/downloads/mikyll/ROQuiz/total
[downloads-url]: https://github.com/mikyll/ROQuiz/releases/latest
[contributors-shield]: https://img.shields.io/github/contributors/mikyll/ROQuiz
[contributors-url]: https://github.com/mikyll/ROQuiz/graphs/contributors
[domande-shield]: https://img.shields.io/static/v1?label=domande&message=87&color=green
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
[stars-shield]: https://img.shields.io/github/stars/mikyll/ROQuiz
[stars-url]: https://github.com/mikyll/ROQuiz/stargazers
[issues-shield]: https://img.shields.io/github/issues/mikyll/ROQuiz
[issues-url]: https://github.com/mikyll/ROQuiz/issues
[license-shield]: https://img.shields.io/github/license/mikyll/ROQuiz
[license-url]: https://github.com/mikyll/ROQuiz/blob/master/LICENSE
[java-shield]: https://img.shields.io/badge/Java-ED8B00?logo=java&logoColor=white
[java-url]: https://www.java.com
[dart-shield]: https://img.shields.io/badge/dart-%230175C2.svg?logo=dart&logoColor=white
[dart-url]: https://dart.dev/
[flutter-shield]: https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white
[flutter-url]: https://flutter.dev/
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?logo=linkedin&colorB=0077B5
[linkedin-url]: https://www.linkedin.com/in/michele-righi/?locale=it_IT
[github-shield]: https://img.shields.io/github/followers/mikyll.svg?style=social&label=Follow
[github-url]: https://github.com/mikyll
