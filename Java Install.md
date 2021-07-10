### Windows
1. Download JavaSE-11 (jdk 11.\*): https://www.oracle.com/java/technologies/javase-jdk11-downloads.html
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(1).png" width="70%"/>
2. Estrarne il contenuto in una directory a piacere (meglio se nella stessa con le altre installazioni Java, di default è "C:\Program Files\Java\")
3. Impostare Path e JAVA_HOME nelle variabili di sistema:

  * Cerca > Variabili > Modifica le variabili di ambiente relative al sistema > Variabili d'ambiente...
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(2).png" width="40%"/><br/>
  * Nel riquadro in alto aggiungere (o modificare se esiste già) alla variabile JAVA_HOME: Nuova... > Nome: JAVA_HOME, Valore: percorso in cui abbiamo scaricato il jdk 11<br/>
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(3).png" width="70%"/><br/>
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(4).png" width="40%"/><br/>
  * Nel riquadro in basso modificare la variabile Path, aggiungendovi il percorso della directory \bin dentro al jdk:
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(5).png" width="40%"/><br/>
  * verificare che Java 11 sia installato correttamente: Cerca > cmd > "java -version" e "javac -version"
  <img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(6).png" width="70%"/>
<br/>
5. Download JavaFX SDK (javafx-sdk-11.\*): https://gluonhq.com/products/javafx/
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(7).png" width="70%"/>
7. Estrarne il contenuto in una directory a piacere (meglio se nella stessa con le altre installazioni Java, di default è "C:\Program Files\Java\")
8. Aprire il file Launcher con un editor di testo e sostituire --module-path="C:\Program Files\Java\javafx-sdk-11.0.2\lib" con il percorso in cui è stato scaricato il jdk
<img src="https://github.com/mikyll/ROQuiz/blob/main/gfx/Java%20Installation%20Guide/InstallJava%20(8).png" width="70%"/>
