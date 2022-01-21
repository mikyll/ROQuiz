package gui;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javafx.application.HostServices;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.control.Spinner;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.SpinnerValueFactory.IntegerSpinnerValueFactory;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import model.Question;
import model.SettingsSingleton;
import persistence.BadFileFormatException;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;

public class ControllerMenu implements IControllerMenu {
	private final static String QUESTIONS_FILENAME = "Domande.txt";
	
	private HostServices hostServies;
	private SettingsSingleton settings;
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
	
	@FXML private Label labelTopicsWarning;
	@FXML private Label labelQuizQNum;
	@FXML private Label labelSelectedQ;
	
	@FXML private Spinner<Integer> spinnerQuestionNumQuiz;
	@FXML private Spinner<Integer> spinnerTimerMin;
	@FXML private CheckBox checkBoxCheckQuestionsUpdate;
	@FXML private Button buttonSettingsSave;
	@FXML private Button buttonSettingsCancel;
	@FXML private Button buttonSettingsRestore;
	
	@FXML private Text textVersion;
	
	// FXML loader call order: Constructor -> initialize(). Inside initialize(), all the fxml object have been already initialized.
	public ControllerMenu()	{}
	
	@FXML @Override 
	public void initialize()
	{
		this.settings = SettingsSingleton.getInstance();
		
		// check for downloads only when the app is launched
		if(this.settings.isJustLaunched())
		{
			this.settings.loadSettings(".settings.json");
			this.settings.setJustLaunched(false);
			
			// download "Domande.txt" from the GitHub repository
			if(this.settings.isCheckQuestionsUpdate())
			{
				System.out.println("Controllo domande aggiornate...");
				boolean res = QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", "tmp.txt");
				
				if(new File(QUESTIONS_FILENAME).exists() && res)
				{
					// a new file has been found.
					if(QuestionRepository.compareFilesLength("Domande.txt", "tmp.txt") > 0)
					{
						System.out.println("È stata trovata una versione più recente del file contenente le domande.");
						Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
						alert.setTitle("Finestra di dialogo");
						alert.setHeaderText("È stata trovata una versione più recente del file contenente le domande. Scaricarla?");
						alert.setContentText("Questa azione sovrascriverà il file " + QUESTIONS_FILENAME + " attualmente presente.");
						alert.showAndWait();
						if (alert.getResult() == ButtonType.YES)
						{
							// update Domande.txt with DomandeNew.txt
							new File(QUESTIONS_FILENAME).delete();
							
							new File("tmp.txt").renameTo(new File(QUESTIONS_FILENAME));
						}
						if (alert.getResult() == ButtonType.NO)
						{
							new File("tmp.txt").delete();
						}
					}
					else {
						System.out.println("Non sono state trovate nuove domande.\n");
						new File("tmp.txt").delete();
					}
				}
				else {
					new File("DomandeNuove.txt").delete();
				}
			}
		}
		
		if(!new File("Domande.txt").exists())
		{
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("File domande non presente, scaricarlo?");
			alert.showAndWait();
			if (alert.getResult() == ButtonType.YES)
			{
				if(!QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", QUESTIONS_FILENAME))
				{
					System.out.println("Download file domande fallito");
					System.exit(1);
				}
			}
			if (alert.getResult() == ButtonType.NO)
			{
				new File("tmp.txt").delete();
				System.out.println("File " + QUESTIONS_FILENAME + " mancante.");
				System.exit(1);
			}
		}
		
		
		// load question repository from file
		this.qRepo = null;
		try (BufferedReader readerQuiz = new BufferedReader(new InputStreamReader(new FileInputStream(QUESTIONS_FILENAME), StandardCharsets.ISO_8859_1))){
			this.qRepo = new QuestionRepository(readerQuiz);
		} catch (FileNotFoundException e) {
			System.out.println("File " + QUESTIONS_FILENAME + " mancante.");
			System.exit(1);
		} catch (IOException e) {
			System.out.println("Errore nella lettura del file " + QUESTIONS_FILENAME);
			System.exit(1);
		} catch (BadFileFormatException e) {
			System.out.println("Errore nella formattazione del file " + QUESTIONS_FILENAME + ": " + e.getMessage() + " (linea " + e.getExceptionLine() + ")");
			System.exit(1);
		}
		
		int qNum = this.qRepo.getQuestions().size();
		if(qNum < this.settings.getQuestionNumber())
		{
			System.out.println("Errore: nel file " + QUESTIONS_FILENAME + " non sono presenti abbastanza domande.\nDomande presenti: " 
					+ this.qRepo.getQuestions().size() + "\nDomande necessarie: " + SettingsSingleton.DEFAULT_QUESTION_NUMBER);
			System.exit(1);
		}
		
		if(this.qRepo.hasTopics())
		{
			this.buttonTopics.setDisable(false);
			this.labelTopicsWarning.setVisible(false);
			
			this.initCheckBoxes();
		}
		
		// setup vbox and panels
		this.vboxMain.setVisible(true);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxBack.setVisible(false);
		this.vboxTopics.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxInfo.setVisible(false);

		// updating settings components
		this.spinnerQuestionNumQuiz.setValueFactory(new IntegerSpinnerValueFactory(
				SettingsSingleton.DEFAULT_QUESTION_NUMBER / 2, qNum, this.settings.getQuestionNumber()));
		this.spinnerTimerMin.setValueFactory(new IntegerSpinnerValueFactory(
				SettingsSingleton.DEFAULT_TIMER / 2, qNum * 2, this.settings.getTimer()));
		this.checkBoxCheckQuestionsUpdate.setSelected(this.settings.isCheckQuestionsUpdate());
		
		this.textVersion.setText("ROQuiz v" + SettingsSingleton.VERSION_NUMBER);
		
		new File("tmp.txt").delete();
	}
	
	public void setQuestionRepository(IQuestionRepository qRepo)
	{
		this.qRepo = qRepo;
	}
	
	@FXML
	public void selectTopics(ActionEvent event)
	{
		System.out.println("Selezione: argomenti.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxTopics.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	public void setTopics(ActionEvent event)
	{
		CheckBox cb = (CheckBox)event.getTarget();
		System.out.println("Argomento '" + cb.getText() + (cb.isSelected() ? "' selezionato." : "' deselezionato."));
		
		int currentTotQuestNum = 0;
		for(int i = 0; i < this.checkBoxes.size(); i++)
		{
			currentTotQuestNum += this.checkBoxes.get(i).isSelected() ? this.qRepo.getqNumPerTopics().get(i) : 0;
		}
		this.labelSelectedQ.setText("" + currentTotQuestNum);
		
		// update checbox disables
		for(int i = 0; i < this.checkBoxes.size(); i++) // disable all the topics the deselection of which would make the question number to be less than the one specified in the settings
		{
			boolean disableCheckBox = false;
			if(this.checkBoxes.get(i).isSelected())
				disableCheckBox = currentTotQuestNum - this.qRepo.getqNumPerTopics().get(i) < this.settings.getQuestionNumber();
			
			this.checkBoxes.get(i).setDisable(disableCheckBox);
		}
	}
	
	@FXML
	public void selectQuiz(ActionEvent event)
	{
		System.out.println("\nSelezione: avvia quiz.\nArgomenti impostati:");
		
		List<Question> questions = new ArrayList<Question>();
		for(int i = 0, j = 0, k; i < this.checkBoxes.size(); i++) // creates a list with questions from just the selected topics
		{
			if(this.checkBoxes.get(i).isSelected())
			{
				System.out.println("-" + this.qRepo.getTopics().get(i));
				
				for(k = 0; k < this.qRepo.getqNumPerTopics().get(i); j++, k++)
				{
					questions.add(this.qRepo.getQuestions().get(j));
				}
			}
			else j += this.qRepo.getqNumPerTopics().get(i);
		}
		
		System.out.println("Pool domande quiz: " + questions.size());
		
		// load
		try {
			FXMLLoader loader = new FXMLLoader(ControllerMenu.class.getResource("/gui/ViewQuiz.fxml"));
			Stage stage = (Stage) this.vboxMain.getScene().getWindow();
			loader.setController(new ControllerQuiz(questions));
			AnchorPane quiz = (AnchorPane) loader.load();
			/*ControllerQuiz controller = loader.getController(); // throws NullPointerException because initialize() will be called before 'List<Question> questions' is set
			controller.setQuestions(questions);*/
		
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(ControllerMenu.class.getResource("/application/application.css").toExternalForm());
			stage.setScene(scene);
			stage.show();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ERRORE: " + e.getMessage());
			System.exit(1);
		}
	}
	
	@FXML
	public void settings(ActionEvent event)
	{
		System.out.println("Selezione: impostazioni.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxSettings.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void info(ActionEvent event)
	{
		System.out.println("Selezione: informazioni.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxInfo.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	public void back(ActionEvent event)
	{
		System.out.println("Selezione: indietro.");
		
		if(this.vboxSettings.isVisible() &&	(this.settings.getQuestionNumber() != this.spinnerQuestionNumQuiz.getValue() || this.settings.getTimer() != this.spinnerTimerMin.getValue()))
		{
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO, ButtonType.CANCEL);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("Salvare le modifiche alle impostazioni?");
			alert.showAndWait();
			if (alert.getResult() == ButtonType.YES)
			{
				this.saveSettingsChanges();
			}
			if(alert.getResult() == ButtonType.NO)
			{
				this.cancelSettingsChanges();
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
	public void saveSettings(ActionEvent event)
	{
		this.saveSettingsChanges();
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML 
	public void cancelSettings(ActionEvent event)
	{
		this.cancelSettingsChanges();
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML
	public void restoreSettings(ActionEvent event)
	{
		System.out.println("Impostazioni di default.");
		
		this.spinnerQuestionNumQuiz.getValueFactory().setValue(SettingsSingleton.DEFAULT_QUESTION_NUMBER);
		this.spinnerTimerMin.getValueFactory().setValue(SettingsSingleton.DEFAULT_TIMER);
		this.checkBoxCheckQuestionsUpdate.setSelected(SettingsSingleton.DEFAULT_CHECK_QUESTIONS_UPDATE);
	}
	
	private void saveSettingsChanges()
	{
		int sqnq, stm;
		boolean cqu;
		sqnq = this.spinnerQuestionNumQuiz.getValue();
		stm = this.spinnerTimerMin.getValue();
		cqu = this.checkBoxCheckQuestionsUpdate.isSelected();
		
		System.out.println("Modifiche alle impostazioni salvate\nNumero domande per quiz: " +
				sqnq + "\nTimer (minuti): " + stm + "\nControllo aggiornamento domande: " + cqu);
		
		this.settings.setQuestionNumber(sqnq);
		this.settings.setTimer(stm);
		this.settings.setCheckQuestionsUpdate(cqu);
		
		if(this.qRepo.hasTopics())
		{
			this.labelSelectedQ.setText("" + this.qRepo.getQuestions().size());
			this.labelQuizQNum.setText("" + sqnq);
			
			for(CheckBox cb : this.checkBoxes)
				cb.setSelected(true);
			this.setDisableCheckBoxes();
		}
		
		this.settings.saveSettings(".settings.json");
	}
	
	private void cancelSettingsChanges()
	{
		System.out.println("Modifiche alle impostazioni annullate.");
		
		this.spinnerQuestionNumQuiz.getValueFactory().setValue(this.settings.getQuestionNumber());
		this.spinnerTimerMin.getValueFactory().setValue(this.settings.getTimer());
		this.checkBoxCheckQuestionsUpdate.setSelected(this.settings.isCheckQuestionsUpdate());
	}
	
	@FXML 
	public void openURL(ActionEvent event)
	{
		Hyperlink hl = (Hyperlink) event.getSource();
		if(hl.getText().equals("mikyll"))
			this.hostServies.showDocument("https://github.com/mikyll");
		if(hl.getText().equals("mikyll/ROQuiz"))
			this.hostServies.showDocument("https://github.com/mikyll/ROQuiz");
		if(hl.getText().equals("Icons8"))
			this.hostServies.showDocument("https://icons8.com");
		if(hl.getText().equals("Apri una issue"))
			this.hostServies.showDocument("https://github.com/mikyll/ROQuiz/issues");
		if(hl.getChildrenUnmodifiable().get(0) instanceof Label)
			this.hostServies.showDocument("https://github.com/mikyll/ROQuiz");
	}
	
	// public void selectQuizFile() {}
	
	private void initCheckBoxes()
	{
		this.checkBoxes = new ArrayList<CheckBox>();
		
		// check if there are enough questions. In case there aren't, the checkbox are disabled
		int qNum = this.qRepo.getQuestions().size();
		this.labelSelectedQ.setText("" + qNum);
		this.labelQuizQNum.setText("" + this.settings.getQuestionNumber());
		
		for(int i = 0; i < this.qRepo.getTopics().size(); i++) // dynamically generates the hbox containing the checkboxed
		{
			CheckBox cb = new CheckBox();
			cb.setPrefWidth(350);
			cb.setPrefHeight(20);
			cb.setText(this.qRepo.getTopics().get(i));
			cb.setOnAction(this::setTopics);
			cb.setSelected(true);
			
			this.checkBoxes.add(cb);
			this.vboxCheckBoxes.getChildren().add(cb);
		}
		this.setDisableCheckBoxes();
	}
	
	private void setDisableCheckBoxes()
	{
		int qNum = this.qRepo.getQuestions().size();
		for(int i = 0; i < this.checkBoxes.size(); i++)
		{
			boolean disableCheckBox = qNum - this.qRepo.getqNumPerTopics().get(i) < this.settings.getQuestionNumber(); // disable checkboxes: they won't be deselectable if that would make the question number to be less than the quiz one.
			this.checkBoxes.get(i).setDisable(disableCheckBox);
		}
	}
	
	public void setHostServices(HostServices hostServices)
	{
		this.hostServies = hostServices;
	}
}
