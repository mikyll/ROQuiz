package application;
	
import java.io.IOException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import persistenece.BadFileFormatException;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;


public class Main extends Application {
	
	@Override
	public void start(Stage stage) throws IOException, BadFileFormatException
	{
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/javafx/ViewQuiz.fxml"));
			AnchorPane quiz = (AnchorPane) loader.load();			
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			stage.setTitle("ROQuiz");
			stage.setScene(scene);
			stage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args)
	{
		launch(args);
	}
}
