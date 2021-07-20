package gui;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import persistence.BadFileFormatException;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;
public class ControllerMenu implements IControllerMenu {
	private IQuestionRepository qRepo;
	
	@FXML private Button buttonTopics;
	@FXML private Button buttonStart;
	@FXML private Button buttonSettings;
	@FXML private Button buttonHelp;
	
	@FXML private Label labelTopics;
	
	public ControllerMenu() {}
	
	@FXML @Override 
	public void initialize()
	{
		try (Reader readerQuiz = new FileReader("QuizDivisiPerArgomento.txt")){
			this.qRepo = new QuestionRepository(readerQuiz);
		} catch (FileNotFoundException e) {
			System.out.println("File Quiz.txt mancante.");
			System.exit(0);
		} catch (IOException e) {
			System.out.println("Errore nella lettura del file Quiz.txt.");
			System.exit(0);
		} catch (BadFileFormatException e) {
			System.out.println("Errore nella formattazione del file: " + e.getMessage() + " (linea " + e.getExceptionLine() + ")");
			System.exit(0);
		}
		
		if(this.qRepo.hasTopics())
		{
			this.buttonTopics.setDisable(false);
			this.labelTopics.setVisible(false);
		}
	}
	
	@FXML
	public void selectTopics(ActionEvent event)
	{
		System.out.println("User selected topics");
	}
	
	private void checkTopics()
	{
		
	}
	
	@FXML
	public void startQuiz(ActionEvent event)
	{
		System.out.println("User selected start quiz");
	}
	
	@FXML
	public void settings(ActionEvent event)
	{
		System.out.println("User selected settings");
	}
	
	@FXML
	public void help(ActionEvent event)
	{
		System.out.println("User selected help");
	}
	
	// public void selectQuizFile() {}
}
