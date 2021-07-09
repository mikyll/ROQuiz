package application;
	
import java.io.IOException;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import persistenece.BadFileFormatException;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;


public class Main extends Application {
	//private Controller controller;
	
	@Override
	public void start(Stage stage) throws IOException, BadFileFormatException
	{
		/*Reader readerQuiz = new FileReader("Quiz.txt");
		IQuestionRepository qRepo = new QuestionRepository(readerQuiz);
		this.controller = new Controller(qRepo);
		if(this.controller == null)
			return;*/
		//this.controller = new Controller("culo");
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/javafx/ViewQuiz.fxml"));
			//loader.setControllerFactory(c -> { return new Controller("ciao");});
			//loader.setController(this.controller);
			AnchorPane quiz = (AnchorPane) loader.load();			
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			stage.setTitle("Cluedo game");
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
