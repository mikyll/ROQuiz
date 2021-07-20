package gui;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import javafx.application.HostServices;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.Spinner;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.SpinnerValueFactory.IntegerSpinnerValueFactory;
import javafx.scene.layout.VBox;
import model.Settings;
import persistence.BadFileFormatException;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;
public class ControllerMenu implements IControllerMenu {
	private HostServices hostServies;
	private Settings settings;
	private IQuestionRepository qRepo;
	
	private List<CheckBox> checkBoxes;
	
	@FXML private VBox vboxMain;
	@FXML private VBox vboxTopics;
	@FXML private VBox vboxCheckBoxes;
	@FXML private VBox vboxSettingsInfo;
	@FXML private VBox vboxSettings;
	@FXML private VBox vboxInfo;	
	@FXML private VBox vboxBack;
	
	@FXML private Button buttonTopics;
	@FXML private Button buttonStart;
	@FXML private Button buttonSettings;
	@FXML private Button buttonInfo;
	
	@FXML private Label labelTopics;
	@FXML private Label labelQuizQNum;
	@FXML private Label labelSelectedQ;
	
	@FXML private Spinner<Integer> spinnerQuestionNumQuiz;
	@FXML private Spinner<Integer> spinnerAnswerNumQuiz;
	@FXML private Spinner<Integer> spinnerTimerMin;
	@FXML private Button buttonSettingsCancel;
	@FXML private Button buttonSettingsSave;
	
	public ControllerMenu() {}
	
	@FXML @Override 
	public void initialize()
	{
		this.settings = Settings.getInstance();
		
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
		
		// setup vbox and panels
		this.vboxMain.setVisible(true);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxBack.setVisible(false);
		this.vboxTopics.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxInfo.setVisible(false);
		
		int qNum = this.qRepo.getQuestions().size();
		this.spinnerQuestionNumQuiz.setValueFactory(new IntegerSpinnerValueFactory(16, qNum, this.settings.getQuestionNumber()));
		this.spinnerAnswerNumQuiz.setValueFactory(new IntegerSpinnerValueFactory(4, 10, this.settings.getAnswerNumber()));
		this.spinnerAnswerNumQuiz.setDisable(true); // answer number is fixed
		this.spinnerTimerMin.setValueFactory(new IntegerSpinnerValueFactory(4, qNum * 2, this.settings.getStartTime()));
	}
	
	@FXML
	public void selectTopics(ActionEvent event)
	{
		System.out.println("User selected topics");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
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
				disableCheckBox = currentTotQuestNum - this.qRepo.getqNumPerTopics().get(i) < Settings.DEFAULT_QUESTION_NUMBER;
			
			System.out.println("A" + i + ": " + this.qRepo.getqNumPerTopics().get(i) + " . " + this.checkBoxes.get(i).isSelected() + " . " + disableCheckBox); // test
			
			this.checkBoxes.get(i).setDisable(disableCheckBox);
		}
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
		this.vboxSettingsInfo.setVisible(false);
		this.vboxSettings.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void info(ActionEvent event)
	{
		System.out.println("User selected Info");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxInfo.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void back(ActionEvent event)
	{
		System.out.println("User selected back");
		
		// Alert di conferma per gli argomenti?
		
		if(this.vboxTopics.isVisible())
		{
			// confirmation
		}
		if(this.vboxSettings.isVisible() &&	(this.settings.getQuestionNumber() != this.spinnerQuestionNumQuiz.getValue() ||
				this.settings.getAnswerNumber() != this.spinnerAnswerNumQuiz.getValue() || this.settings.getStartTime() != this.spinnerTimerMin.getValue()))
		{
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO, ButtonType.CANCEL);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("Salvare le modifiche alle impostazioni?");
			alert.showAndWait();
			if (alert.getResult() == ButtonType.YES)
			{
				System.out.println("Modifiche alle impostazioni salvate\nNumero domande per quiz: " +
						this.spinnerQuestionNumQuiz.getValue() + "\nNumero risposte: " + this.spinnerAnswerNumQuiz.getValue() +
						"\nTimer (minuti): " + this.spinnerTimerMin.getValue());
				
				this.settings.setQuestionNumber(this.spinnerQuestionNumQuiz.getValue());
				this.settings.setAnswerNumber(this.spinnerAnswerNumQuiz.getValue());
				this.settings.setStartTime(this.spinnerTimerMin.getValue());
			}
			if(alert.getResult() == ButtonType.NO)
			{
				System.out.println("Setting changes canceled");
				
				this.spinnerQuestionNumQuiz.getValueFactory().setValue(this.settings.getQuestionNumber());
				this.spinnerAnswerNumQuiz.getValueFactory().setValue(this.settings.getAnswerNumber());
				this.spinnerTimerMin.getValueFactory().setValue(this.settings.getStartTime());
			}
			if(alert.getResult() == ButtonType.CANCEL)
				return;
		}
		
		this.vboxBack.setVisible(false);
		this.vboxTopics.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxInfo.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML 
	public void cancelSettings(ActionEvent event)
	{
		System.out.println("Setting changes canceled");
		
		this.spinnerQuestionNumQuiz.getValueFactory().setValue(this.settings.getQuestionNumber());
		this.spinnerAnswerNumQuiz.getValueFactory().setValue(this.settings.getAnswerNumber());
		this.spinnerTimerMin.getValueFactory().setValue(this.settings.getStartTime());
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML 
	public void saveSettings(ActionEvent event)
	{
		System.out.println("Modifiche alle impostazioni salvate\nNumero domande per quiz: " +
				this.spinnerQuestionNumQuiz.getValue() + "\nNumero risposte: " + this.spinnerAnswerNumQuiz.getValue() +
				"\nTimer (minuti): " + this.spinnerTimerMin.getValue());
		
		this.settings.setQuestionNumber(this.spinnerQuestionNumQuiz.getValue());
		this.settings.setAnswerNumber(this.spinnerAnswerNumQuiz.getValue());
		this.settings.setStartTime(this.spinnerTimerMin.getValue());
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML 
	public void openURL(ActionEvent event)
	{
		Hyperlink hl = (Hyperlink) event.getSource();
		if(hl.getText().equals("mikyll"))
			this.hostServies.showDocument("https://github.com/mikyll");
		if(hl.getText().equals("mikyll/ROQuiz"))
			this.hostServies.showDocument("https://github.com/mikyll/ROQuiz");
		if(hl.getText().equals("Icon8"))
			this.hostServies.showDocument("https://icons8.com");
	}
	
	// public void selectQuizFile() {}
	
	private void initCheckBoxes()
	{
		this.checkBoxes = new ArrayList<CheckBox>();
		
		// check if there are enough questions. In case there aren't, the checkbox are disabled
		int qNum = this.qRepo.getQuestions().size();
		this.labelSelectedQ.setText("" + qNum);
		this.labelQuizQNum.setText("" + Settings.DEFAULT_QUESTION_NUMBER);
		boolean enoughQuestions = qNum >= Settings.DEFAULT_QUESTION_NUMBER;
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
			
			boolean disableCheckBox = qNum - this.qRepo.getqNumPerTopics().get(i) < Settings.DEFAULT_QUESTION_NUMBER;
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
	
	public void setHostServices(HostServices hostServices)
	{
		this.hostServies = hostServices;
	}
}
