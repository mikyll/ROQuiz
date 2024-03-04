# Eclipse Project Setup

## Indice

<details open="open">
  <summary></summary>
  
  <ol>
    <li>
      <a href="#installazione-java">Installazione Java</a>
      <ul>
        <li><a href="#esempio-windows">Esempio Windows</a></li>
      </ul>
    </li>
    <li>
     <a href="#setup-progetto">Setup progetto</a>
    </li>
    <li>
     <a href="#build-jre-con-javafx">Build JRE con JavaFX</a>
     <ul>
      <li><a href="#windows">Windows</a></li>
      <li><a href="#linux">Linux</a></li>
     </ul>
    </li>
  </ol>
</details>

## Installazione Java

### Esempio Windows
1. Scaricare Java 11 (jdk-11.0.11) o una versione più recente: https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(1).png" width="70%"/><br/><br/>
2. Estrarne il contenuto in una directory a piacere (meglio se nella stessa con le altre installazioni Java, di default è "C:\Program Files\Java\")<br/>
3. Impostare Path e JAVA_HOME nelle variabili di sistema:

  * Cerca > Variabili > Modifica le variabili di ambiente relative al sistema > Variabili d'ambiente...
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(2).png" width="40%"/><br/><br/>
  * Nel riquadro in alto aggiungere (o modificare se esiste già) alla variabile JAVA_HOME: Nuova... > Nome: JAVA_HOME, Valore: percorso in cui abbiamo scaricato il jdk 11<br/>
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(3).png" width="70%"/><br/><br/>
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(4).png" width="40%"/><br/><br/>
  * Nel riquadro in basso modificare la variabile Path, aggiungendovi il percorso della directory \bin dentro al jdk:
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(5).png" width="40%"/><br/><br/>
  * verificare che Java 11 sia installato correttamente: Cerca > cmd > "java -version" e "javac -version"
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(6).png" width="70%"/>
<br/><br/>
4. Download JavaFX 11 (javafx-sdk-11.0.2): https://gluonhq.com/products/javafx/
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(7).png" width="70%"/><br/>
5. Estrarne il contenuto in una directory a piacere (meglio se nella stessa con le altre installazioni Java, di default è "C:\Program Files\Java\").

## Setup progetto
1. Installare l'ultima versione di Eclipse [download Eclipse](https://www.eclipse.org/downloads/).
2. Controllare che Eclipse utilizzi una JRE adeguata (almeno 11.0): Window > Preferences > Java > Installed JREs.<br/>
In caso contrario aggiungerla: Add > Standard VM > Directory... (selezionare la directory dell'JDK).
3. Scaricare JavaFX 11 o più recente, sia SDK che JMOD (https://gluonhq.com/products/javafx/). 
4. Clonare la repository.
5. Importare il progetto su Eclipse.
6. Creare una User Library con le librerie di JavaFX: Window > Preferences > Java > Build Path > User Libraries > New > User library name (es: "JavaFX11") > Add External JARs > aggiungere i .jar che si trovano nell'SDK, nella directory lib/
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(1).png" width="60%"/> <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(2).png" width="30%"/><br/><br/>
7. Aggiungere la User Library appena creata al Modulepath: tasto destro sul progetto > Build Path > Configure Build Path... > Libraries > Modulepath > Add Library... > User Library > JavaFX (es. JavaFX11).<br/>
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(3).png" width="40%"/> <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(4).png" width="59%"/><br/>
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(5).png" width="40%"/><br/><br/>
8. Aggiungere i moduli necessari come argomenti nella Run Configuration:
Windows: Tasto destro sulla classe application.Main > Run > Run Configurations > Arguments > aggiungere in VM arguments: --module-path "mods;<path/to/javafx-sdk>\lib" -m roquiz/application.Main > Apply.
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Project%20Setup/Project%20Setup%20(6).png" width="60%"/>
Linux: Tasto destro sulla classe application.Main > Run > Run Configurations > Arguments > aggiungere in VM arguments: --module-path "mods:<path/to/javafx-sdk>\lib" -m roquiz/application.Main > Apply.
NB: la differenza è il separatore ';' su Windows e ':' su Linux (avrei voluto scoprirlo subito invece di perdere 3 giorni a cercare di capire come mai non trovava il modulo roquiz :) )
Ora l'applicazione è pronta per essere eseguita all'interno di Eclipse.

## Build JRE con JavaFX
Per eseguire l'applicazione standalone è necessario buildare una jre che includa JavaFX: per farlo si può usare jlink, che è compreso nell'installazione Java.
### Windows
<pre>
jlink --module-path "path/to/jaavafx-jmods";mods --add-modules=roquiz --output fxjreWin --compress=2 --strip-debug --no-header-files --no-man-pages
</pre>

### Linux
NB: controllare con java -version che sia installato Java 11 o una versione più recente.
<pre>
jlink --module-path "path/to/jaavafx-jmods":mods --add-modules=roquiz --output fxjreLin --compress=2 --strip-debug --no-header-files --no-man-pages
</pre>


