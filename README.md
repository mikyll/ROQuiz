[![Downloads][downloads-shield]][downloads-url]
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
[![GitHub followers][github-shield]][github-url]

<h1 align="center">ROQuiz</h1>
Semplice applicazione grafica Java per esercitarsi con i <b>quiz del corso Ricerca Operativa M</b>.
È possibile caricare un file con le varie domande, quindi si possono inserire eventuali domande nuove o personalizzate;
il timer è impostato a 18 minuti, per ora si può modificare solo via codice sorgente;
mostra le risposte giuste e quelle sbagliate.

Chiunque voglia contribuire è liberissimo di fare una fork e aggiungere e implementare feature nuove o sistemare parti del codice già esistente (perché fa schifo ma funziona).

<b>Non mi assumo responsabilità di alcun tipo nel caso di errori nelle domande o nelle risposte, né tantomento nel caso di bocciature potenti</b>. Fatene un buon uso e buona fortuna con l'esame <3

### Demo
<table style="border: none">
  <tr>
    <td width="49.9%"><img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/%5BGIF%5D%20EndQuiz.gif" alt="EndQuizGIF"/></td>
    <td width="49.9%"><img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/%5BGIF%5D%20Timeout.gif" alt="TimeoutGIF"/></td>
  </tr>
  <tr>
    <td>Terminazione quiz</td>
    <td>Tempo scaduto</td>
  </tr>
</table>

### Esecuzione
1. Scaricare l'<a href="https://github.com/mikyll/ROQuiz/releases/latest">ultima release</a> ed estrarre il contenuto.
2. Eseguire Launcher con doppioclick.

### Formattazione domande
Le domande sono caricate da un file Quiz.txt che ha il seguente formato:
* una riga per la domanda;
* 5 righe per le risposte (la riga inizia con una lettera maiuscola, seguita da un punto e dalla risposta);
* una riga per la risposta corretta (una lettera da A a E).
* una riga vuota se non è l'ultima domanda.

NB: non è importante la lettera con cui iniziano le risposte, basta che siano in ordine, altrimenti la risposta giusta e la lettera non corrispondono (sarà necessario aggiungere ulteriori controlli).

esempio (due domande nel file Quiz.txt):
<pre>
Sia P il problema ILP e L(P) il suo rilassamento continuo. Se L(P) è illimitato, allora:
A. P è sempre impossibile
B. non si può dire nulla su P
C. P è sempre illimitato
D. P è illimitato salvo casi molto particolari
E. nessuna di queste
D

In un tableau del simplesso duale, gli elementi della riga 0 (colonna da 1 a n):
A. sono tutti positivi o nulli.
B. sono tutti positivi.
C. sono tutti negativi.
D. sono tutti nulli.
E. Nessuna di queste.
A
</pre>

### Roadmap
Features da aggiungere e sviluppi futuri:
* deploy su Linux e MacOs
* aggiungere menu
* aggiungere alla persistenza la specifica dell'argomento (con una keyword o un carattere speciale, tipo '@' a inizio riga). E magari aggiungere la lista dinamica degli argomenti caricati dal file, in cui si può mettere un tick su quelli da selezionare per il quiz.
* aggiungere test di formattazione del documento caricato (segnalare la riga errata)
* aggiungere file di configurazione per timer e numero di domande
* aggiungere test duplicati
* fare il porting su mobile (magari Android)

### Built With
Per l'implementazione ho utilizzato Java 11 e JavaFX 11, come IDE Eclipse (versione 2020-03 (4.15.0)), e SceneBuilder per la creazione della grafica (file FXML). Vedere i passi seguiti per il [setup del progetto](https://github.com/mikyll/ROQuiz/blob/main/Project%20setup.md).

versione Java: JavaSE-11 (jdk-11.0.11)<br/>
versione JavaFX: JavaFX 11 (javafx-sdk-11.0.2)

### References
* Guida a classe Timeline usata per realizzare il countdown: [Timers in JavaFX and ReactFX](https://tomasmikula.github.io/blog/2014/06/04/timers-in-javafx-and-reactfx.html)
* Lavorare coi moduli Java: [Java 9 Modules in Eclipse](https://blogs.oracle.com/java/post/how-to-develop-modules-with-eclipse-ide)
* Creare jre custom con JavaFX (jlink): [Custom jre with JavaFX 11](https://stackoverflow.com/questions/52966195/custom-jre-with-javafx-11)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[downloads-shield]: https://img.shields.io/github/downloads/mikyll/ROQuiz/total
[downloads-url]: https://github.com/mikyll/ROQuiz/releases/latest
[contributors-shield]: https://img.shields.io/github/contributors/mikyll/ROQuiz
[contributors-url]: https://github.com/mikyll/ROQuiz/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/mikyll/ROQuiz
[forks-url]: https://github.com/mikyll/ROQuiz/network/members
[stars-shield]: https://img.shields.io/github/stars/mikyll/ROQuiz
[stars-url]: https://github.com/mikyll/ROQuiz/stargazers
[issues-shield]: https://img.shields.io/github/issues/mikyll/ROQuiz
[issues-url]: https://github.com/mikyll/ROQuiz/issues
[license-shield]: https://img.shields.io/github/license/mikyll/ROQuiz
[license-url]: https://github.com/mikyll/ROQuiz/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?logo=linkedin&colorB=0077B5
[linkedin-url]: https://www.linkedin.com/in/michele-righi/?locale=it_IT
[github-shield]: https://img.shields.io/github/followers/mikyll.svg?style=social&label=Follow
[github-url]: https://github.com/mikyll
