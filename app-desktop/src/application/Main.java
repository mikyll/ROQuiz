package application;

import gui.ControllerMenu;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;

public class Main extends Application {
	
	/*
	// To load directly the quiz
	@Override
	public void start(Stage stage)
	{
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/gui/ViewQuiz.fxml"));
			AnchorPane quiz = (AnchorPane) loader.load();			
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			stage.setTitle("ROQuiz");
			stage.setScene(scene);
			stage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}*/
	
	@Override
	public void start(Stage stage)
	{	
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/gui/ViewMenu.fxml"));
			AnchorPane menu = (AnchorPane) loader.load();
			ControllerMenu controller = loader.getController();
			controller.setHostServices(getHostServices());
			Scene scene = new Scene(menu);
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