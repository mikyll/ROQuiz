### Setup Eclipse
1. Scaricare almeno Java 11 e JavaFX 11 ([piccola guida](https://github.com/mikyll/ROQuiz/blob/main/Java%20Install.md))
2. Controllare che nel build path del progetto Eclipse nel Modulepath sia impostato il JDK 11 (es. jdk-11.0.11):
  Project > Properties > Java Build Path > Projects
3. Creare una user library con l'SDK di JavaFX 11:
  Eclipse > Windows > Preferences > Java > Build Path > User Libraries > New (chiamarla JavaFX11, e selezionare "system library") > Add External JARs
   Quindi selezionare tutti i jar presenti in javafx-sdk-11.0.2\lib.
4. Aggiungere la nuova libreria al Modulepath: Add Library > User Library > Next > JavaFX11 [system library] > Finish

![image](https://user-images.githubusercontent.com/56556806/125335426-d4ac1880-e34c-11eb-888c-e23f1ebf9865.png)


Per eseguirlo senza creare moduli per l'applicazione aggiungere i seguenti parametri in Run Configuration: --module-path="<path\to\javafx-sdk>\lib"
--add-modules=javafx.controls,javafx.fxml

Altrimenti creare il modulo dell'applicazione (il relativo [module-info.java](https://github.com/mikyll/ROQuiz/blob/main/src/module-info.java), con specificate le dipendenze).
Dunque aggiungere i seguenti parametri in Run Configuration: --module-path "mods;<path\to\javafx-sdk>\lib" -m roquiz/application.Main

Con quest'ultimo metodo potremo poi utilizzare jlink per creare una JRE custom per la nostra applicazione.

### Creazione JRE Custom
jlink per creare la jre (da CMD):
jlink --module-path "<path\to\javafx-jmod>\lib";mods --add-modules=roquiz --output fxjre

### Creazione JAR ed esecuzione con la JRE appena creata
Eclipse > File > Export > Java > Runnable JAR file (controllare che il main sia quello giusto).

A questo punto possiamo utilizzare il comando java della jre per avviare l'applicazione, da linea di comando o tramite un launcher:
fxjre\bin\java -m roquiz/application.Main
