package gui;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import model.Settings;
import persistence.BadFileFormatException;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;
public class ControllerMenu implements IControllerMenu {
	private IQuestionRepository qRepo;
	
	private List<CheckBox> checkBoxes;
	
	@FXML private VBox vboxMain;
	@FXML private VBox vboxTopics;
	@FXML private VBox vboxCheckBoxes;
	@FXML private VBox vboxSettingsHelp;
	@FXML private VBox vboxSettings;
	@FXML private VBox vboxHelp;	
	@FXML private VBox vboxBack;
	
	@FXML private Button buttonTopics;
	@FXML private Button buttonStart;
	@FXML private Button buttonSettings;
	@FXML private Button buttonHelp;
	
	@FXML private Label labelTopics;
	@FXML private Label labelQuizQNum;
	@FXML private Label labelSelectedQ;
	
	public ControllerMenu() {}
	
	@FXML @Override 
	public void initialize()
	{
		try (Reader readerQuiz = new FileReader("QuizDivisiPerArgomentoTest.txt")){
			this.qRepo = new QuestionRepository(readerQuiz);
		} catch (FileNotFoundException e) {
			System.out.println("File Quiz.txt mancante.");
			System.exit(1);
		} catch (IOException e) {
			System.out.println("Errore nella lettura del file Quiz.txt.");
			System.exit(1);
		} catch (BadFileFormatException e) {
			System.out.println("Errore nella formattazione del file: " + e.getMessage() + " (linea " + e.getExceptionLine() + ")");
			System.exit(1);
		}
		
		if(this.qRepo.hasTopics())
		{
			this.buttonTopics.setDisable(false);
			this.labelTopics.setVisible(false);
			
			// popolare mappa?
			this.initCheckBoxes();
		}
	}
	
	@FXML
	public void selectTopics(ActionEvent event)
	{
		System.out.println("User selected topics");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsHelp.setVisible(false);
		this.vboxTopics.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	public void setTopics(ActionEvent event)
	{
		CheckBox cb = (CheckBox)event.getTarget();
		System.out.println("User " + (cb.isSelected() ? "selected " : "deselected ") + cb.getText());
		
		int currentTotQuestNum = 0;
		for(int i = 0; i < this.checkBoxes.size(); i++)
		{
			currentTotQuestNum += this.checkBoxes.get(i).isSelected() ? this.qRepo.getqNumPerTopics().get(i) : 0;
		}
		this.labelSelectedQ.setText("" + currentTotQuestNum);
		System.out.println(currentTotQuestNum); // test
		
		// update checbox disables
		for(int i = 0; i < this.checkBoxes.size(); i++) // disable all the topics the deselection of which would make the question number to be less than the one specified in the settings
		{
			boolean disableCheckBox = false;
			if(this.checkBoxes.get(i).isSelected())
				disableCheckBox = currentTotQuestNum - this.qRepo.getqNumPerTopics().get(i) < Settings.QUESTION_NUMBER;
			
			System.out.println("A" + i + ": " + this.qRepo.getqNumPerTopics().get(i) + " . " + this.checkBoxes.get(i).isSelected() + " . " + disableCheckBox); // test
			
			this.checkBoxes.get(i).setDisable(disableCheckBox);
		}
	}
	
	private void checkTopics()
	{
		
	}
	
	@FXML
	public void startQuiz(ActionEvent event)
	{
		System.out.println("User selected start quiz");
		
		// crea lista di domande scorrendo le checkbox e controllando gli argomenti abilitati
	}
	
	@FXML
	public void settings(ActionEvent event)
	{
		System.out.println("User selected settings");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsHelp.setVisible(false);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void help(ActionEvent event)
	{
		System.out.println("User selected help");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsHelp.setVisible(false);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void back(ActionEvent event)
	{
		System.out.println("User selected main menu");
		
		// Alert di conferma per gli argomenti?
		
		this.vboxBack.setVisible(false);
		this.vboxTopics.setVisible(false);
		this.vboxSettingsHelp.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	// public void selectQuizFile() {}
	
	private void initCheckBoxes()
	{
		this.checkBoxes = new ArrayList<CheckBox>();
		
		// check if there are enough questions. In case there aren't, the checkbox are disabled
		int qNum = this.qRepo.getQuestions().size();
		this.labelSelectedQ.setText("" + qNum);
		this.labelQuizQNum.setText("" + Settings.QUESTION_NUMBER);
		boolean enoughQuestions = qNum >= Settings.QUESTION_NUMBER;
		if(!enoughQuestions)
		{
			// exception ?
			System.out.println("Non ci sono abbastanza domande");
			System.exit(1);
		}
		
		for(int i = 0; i < this.qRepo.getTopics().size(); i++) // dynamically generates the hbox containing the checkboxed
		{
			CheckBox cb = new CheckBox();
			cb.setPrefWidth(350);
			cb.setPrefHeight(20);
			cb.setText(this.qRepo.getTopics().get(i));
			cb.setOnAction(this::setTopics);
			
			boolean disableCheckBox = qNum - this.qRepo.getqNumPerTopics().get(i) < Settings.QUESTION_NUMBER;
			cb.setSelected(true);
			cb.setDisable(disableCheckBox);
			
			this.checkBoxes.add(cb);
			this.vboxCheckBoxes.getChildren().add(cb);
		}
		
		for(int i = 0; i < this.checkBoxes.size(); i++) // test
		{
			System.out.println(this.checkBoxes.get(i).getText() + ": " + this.qRepo.getqNumPerTopics().get(i));
		}
	}
}
