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
Ho problemi con le installazioni di Java e non riesco a compilare con una versione differente dalla 10.0.2, cercherò di risolvere ma non assicuro nulla.

<b>Non mi assumo responsabilità di alcun tipo nel caso di errori nelle domande o nelle risposte, né tantomento nel caso di bocciature potenti</b>. Fatene un buon uso e buona fortuna con l'esame <3

### Roadmap
Features da aggiungere e sviluppi futuri:
* aggiungere menu
* aggiungere test di formattazione del documento caricato (segnalare la riga errata)
* aggiungere test duplicati
* aggiungere file di configurazione per timer e numero di domande
* fare il porting su mobile (magari Android)

### Built With
Per l'implementazione ho utilizzato JavaFX SDK e JavaSE-10 (jre-10.0.2), come IDE Eclipse (versione 2020-03 (4.15.0), Build id: 20200313-1211), e SceneBuilder per l'impostazione degli elementi grafici.

Java version: 10.0.2

### References
Guida a classe Timeline usata per realizzare il countdown: [Timers in JavaFX and ReactFX](https://tomasmikula.github.io/blog/2014/06/04/timers-in-javafx-and-reactfx.html)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
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
[linkedin-url]: https://www.linkedin.com/in/michele-righi-095283195/?locale=it_IT
[github-shield]: https://img.shields.io/github/followers/mikyll.svg?style=social&label=Follow
[github-url]: https://github.com/mikyll
