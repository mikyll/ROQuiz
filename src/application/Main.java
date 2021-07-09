package application;
	
import java.io.FileReader;
import java.io.Reader;

import controller.Controller;
import javafx.QuizPane;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;


public class Main extends Application {
	private Controller controller;
	
	@Override
	public void start(Stage stage)
	{
		/*this.controller = createController();
		if(this.controller == null)
			return;*/
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/javafx/ViewQuiz.fxml"));
			AnchorPane homeUtente = (AnchorPane) loader.load();
			// loader.setController();
			Scene scene = new Scene(homeUtente);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			stage.setTitle("Cluedo game");
			stage.setScene(scene);
			stage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	/*protected Controller createController()
	{
		try (Reader readerQuiz = new FileReader("Quiz.txt")) {
			
		}
		// read file
		
	}*/
	
	public static void main(String[] args)
	{
		launch(args);
	}
}
