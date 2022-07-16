package gui;

import java.io.File;
import java.io.IOException;
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
import javafx.scene.control.Tooltip;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.ListView;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import model.Answer;
import model.Question;
import model.Settings;
import persistence.*;

public class ControllerMenu {
	private HostServices hostServices;
	private static SettingsManager settings;
	private IQuestionRepository qRepo;
	
	private List<CheckBox> checkBoxesTopics;
	
	@FXML private VBox vboxMain;
	@FXML private VBox vboxTopics;
	@FXML private VBox vboxQuestions;
	@FXML private VBox vboxCheckBoxes;
	@FXML private VBox vboxSettingsInfo;
	@FXML private VBox vboxSettings;
	@FXML private VBox vboxInfo;
	@FXML private VBox vboxCredits;
	@FXML private VBox vboxBack;
	
	@FXML private Button buttonTopics;
	@FXML private Button buttonStart;
	@FXML private Button buttonSettings;
	@FXML private Button buttonInfo;
	
	@FXML private Label labelTopic;
	
	@FXML private Label labelTopicsWarning;
	@FXML private Label labelLoadedQ;
	@FXML private Label labelSelectedQ;
	@FXML private Label labelQuizQNum;
	
	@FXML private ListView<VBox> listViewQuestions;
	
	@FXML private Spinner<Integer> spinnerQuestionNumQuiz;
	@FXML private Spinner<Integer> spinnerTimerMin;
	@FXML private CheckBox checkBoxShuffleAnswers;
	@FXML private CheckBox checkBoxDarkTheme;
	@FXML private CheckBox checkBoxUpdateQuestions;
	@FXML private Button buttonUpdateQuestions;
	@FXML private CheckBox checkBoxUpdateApp;
	@FXML private Button buttonUpdateApp;
	@FXML private Button buttonSettingsSave;
	@FXML private Button buttonSettingsCancel;
	@FXML private Button buttonSettingsRestore;
	
	@FXML private Label labelVersion;
	
	// FXML loader call order: Constructor -> initialize(). Inside initialize(), all the fxml object have been already initialized.
	public ControllerMenu(IQuestionRepository repository)
	{
		this.qRepo = repository;
	}
	
	@FXML
	private void initialize()
	{
		settings = SettingsManager.getInstance();
		
		int qNum = this.qRepo.getQuestions().size();
		if(qNum < settings.getQuestionNumber())
		{
			System.out.println("Errore: nel file " + SettingsManager.QUESTIONS_FILENAME + " non sono presenti abbastanza domande.\nDomande presenti: " 
					+ this.qRepo.getQuestions().size() + "\nDomande necessarie: " + SettingsManager.DEFAULT_QUESTION_NUMBER);
			System.exit(1);
		}
		
		if(!settings.isSettingsValid(qNum))
		{
			System.out.println("Warning: il file delle impostazioni contiene impostazioni non valide e verrà ripristinato.");
			settings.resetSettings(".settings.json");
		}
		
		// update components based on QuestionRepository and Settings
		this.updateQuestionRepositoryInfo(qNum);
		this.updateSettingsComponents(qNum);
		
		// setup vbox and panels
		this.vboxMain.setVisible(true);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxBack.setVisible(false);
		this.vboxTopics.setVisible(false);
		this.vboxQuestions.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxInfo.setVisible(false);
		this.vboxCredits.setVisible(false);
		
		this.labelVersion.setText("ROQuiz v" + SettingsManager.VERSION_NUMBER);
	}
	
	private void updateQuestionRepositoryInfo(int qNum)
	{
		this.labelLoadedQ.setText("" + qNum);
		
		if(this.qRepo.hasTopics())
		{
			this.buttonTopics.setDisable(false);
			this.labelTopicsWarning.setVisible(false);
			
			this.initCheckBoxes();
		}
		else
		{
			this.buttonTopics.setDisable(true);
			this.labelTopicsWarning.setVisible(true);
		}
	}
	
	private void updateSettingsComponents(int qNum)
	{
		this.spinnerQuestionNumQuiz.setValueFactory(new IntegerSpinnerValueFactory(
				SettingsManager.DEFAULT_QUESTION_NUMBER / 2, qNum, settings.getQuestionNumber()));
		this.spinnerTimerMin.setValueFactory(new IntegerSpinnerValueFactory(
				SettingsManager.DEFAULT_TIMER / 2, qNum * 2, settings.getTimer()));
		this.checkBoxShuffleAnswers.setSelected(settings.isShuffleAnswers());
		this.checkBoxDarkTheme.setSelected(settings.isDarkTheme());
		this.checkBoxUpdateQuestions.setSelected(settings.isCheckQuestionsUpdate());
		this.checkBoxUpdateApp.setSelected(settings.isCheckAppUpdate());
	}
	
	@FXML
	private void selectTopics(ActionEvent event)
	{
		System.out.println("Selezione: argomenti.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxTopics.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	private void setTopics(ActionEvent event)
	{
		CheckBox cb = (CheckBox)event.getTarget();
		System.out.println("Argomento '" + cb.getText() + (cb.isSelected() ? "' selezionato." : "' deselezionato."));
		
		int currentTotQuestNum = 0;
		for(int i = 0; i < this.checkBoxesTopics.size(); i++)
		{
			currentTotQuestNum += this.checkBoxesTopics.get(i).isSelected() ? this.qRepo.getqNumPerTopics().get(i) : 0;
		}
		this.labelSelectedQ.setText("" + currentTotQuestNum);
		
		// update checbox disables
		for(int i = 0; i < this.checkBoxesTopics.size(); i++) // disable all the topics the deselection of which would make the question number to be less than the one specified in the settings
		{
			boolean disableCheckBox = false;
			if(this.checkBoxesTopics.get(i).isSelected())
				disableCheckBox = currentTotQuestNum - this.qRepo.getqNumPerTopics().get(i) < settings.getQuestionNumber();
			
			this.checkBoxesTopics.get(i).setDisable(disableCheckBox);
		}
	}
	
	private void showQuestions(ActionEvent event)
	{
		int topicIndex = 0, qNum = 0;
		CheckBox cbTopic = ((CheckBox) ((HBox) ((Button) event.getSource()).getParent()).getChildren().get(0));
		String topic = cbTopic.getText().replace("(", "").replace(")", "").replaceAll("[0-9]*", "").trim();
		this.labelTopic.setText("Argomento: " + topic);
		
		System.out.println("Selezione: lista domande per l'argomento '" + topic + "'.");
		
		this.vboxTopics.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxQuestions.setVisible(true);
		this.vboxBack.setVisible(true);
		
		for(int i = 0; i < this.qRepo.getTopics().size(); i++)
		{
			qNum = this.qRepo.getqNumPerTopics().get(i);
			if(this.checkBoxesTopics.get(i).equals(cbTopic))
				break;
			topicIndex += qNum;
		}
		
		ObservableList<VBox> listVBox = FXCollections.observableArrayList();
		
		// build ListView
		for(int i = topicIndex; i < topicIndex + qNum; i++)
		{
			Question q = this.qRepo.getQuestions().get(i);
			VBox vbox = new VBox();
			vbox.setMaxWidth(this.vboxQuestions.getPrefWidth() - 30.0);
			vbox.setPadding(new Insets(0, 0, 20, 0));
			
			Label lQuestion = new Label("Q" + (i+1) + ") " + q.getQuestion());
			lQuestion.setStyle("-fx-font-weight: bold");
			lQuestion.setMaxWidth(this.vboxQuestions.getPrefWidth() - 40.0);
			lQuestion.setWrapText(true);
			vbox.getChildren().add(lQuestion);
			
			for(int j = 0; j < q.getAnswers().keySet().size(); j++)
			{
				Answer a = Answer.values()[j];
				char letter = ((char) (j + 65));
				
				HBox hbox = new HBox();
				Label lLetter = new Label(letter + ". ");
				Label lAnswer = new Label(q.getAnswers().get(a));
				lAnswer.setMaxWidth(this.vboxQuestions.getPrefWidth() - 60.0);
				lAnswer.setWrapText(true);
				if(q.getCorrectAnswer().equals(a))
				{
					lLetter.setStyle("-fx-text-fill: rgb(0,200,0);");
					lAnswer.setStyle("-fx-text-fill: rgb(0,200,0);");
				}
				
				hbox.getChildren().addAll(lLetter, lAnswer);
				vbox.getChildren().add(hbox);
			}
			listVBox.add(vbox);
		}
		this.listViewQuestions.setItems(listVBox);
	}
	
	
	@FXML
	private void selectQuiz(ActionEvent event)
	{
		System.out.println("\nSelezione: avvia quiz.\nArgomenti impostati:");
		
		List<Question> questions = new ArrayList<Question>();
		if(this.qRepo.hasTopics())
		{
			// scroll the topics list and for each selected one add its questions to the quiz pool
			for(int i = 0, j = 0, k; i < this.checkBoxesTopics.size(); i++)
			{
				if(this.checkBoxesTopics.get(i).isSelected())
				{
					System.out.println("-" + this.qRepo.getTopics().get(i));
					
					for(k = 0; k < this.qRepo.getqNumPerTopics().get(i); j++, k++)
					{
						questions.add(this.qRepo.getQuestions().get(j));
					}
				}
				else j += this.qRepo.getqNumPerTopics().get(i); // skip the topic
			}
		}
		else
		{
			questions = this.qRepo.getQuestions();
		}
		
		System.out.println("Pool domande quiz: " + questions.size());
		
		// load quiz
		try {
			FXMLLoader loader = new FXMLLoader(ControllerMenu.class.getResource("/gui/ViewQuiz.fxml"));
			Stage stage = (Stage) this.vboxMain.getScene().getWindow();
			ControllerQuiz controller = new ControllerQuiz(questions);
			controller.setHostServices(this.hostServices);
			loader.setController(controller);
			AnchorPane quiz = (AnchorPane) loader.load();
			/*ControllerQuiz controller = loader.getController(); // throws NullPointerException because initialize() will be called before 'List<Question> questions' is set
			controller.setQuestions(questions);*/
		
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
			stage.setScene(scene);
			stage.show();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ERRORE: " + e.getMessage());
			System.exit(1);
		}
	}
	
	@FXML
	private void selectSettings(ActionEvent event)
	{
		System.out.println("Selezione: impostazioni.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxSettings.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	private void selectInfo(ActionEvent event)
	{
		System.out.println("Selezione: informazioni.");
		
		this.vboxMain.setVisible(false);
		this.vboxSettingsInfo.setVisible(false);
		this.vboxInfo.setVisible(true);
		this.vboxBack.setVisible(true);
	}
	
	@FXML
	private void selectCredits(ActionEvent event)
	{
		System.out.println("Selezione: crediti.");
		
		this.vboxInfo.setVisible(false);
		this.vboxCredits.setVisible(true);
	}
	
	@FXML
	private void selectBack(ActionEvent event)
	{
		System.out.println("Selezione: indietro.");
		
		Settings currentSettings = new Settings("", this.spinnerQuestionNumQuiz.getValue(), this.spinnerTimerMin.getValue(),
				this.checkBoxShuffleAnswers.isSelected(), this.checkBoxDarkTheme.isSelected(),
				this.checkBoxUpdateQuestions.isSelected(), this.checkBoxUpdateApp.isSelected());
		if(this.vboxSettings.isVisible() && !settings.equals(currentSettings))
		{
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO, ButtonType.CANCEL);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("Salvare le modifiche alle impostazioni?");
			alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
			
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
		
		if(this.vboxQuestions.isVisible())
		{
			this.vboxQuestions.setVisible(false);
			this.vboxTopics.setVisible(true);
		}
		else if(this.vboxCredits.isVisible())
		{
			this.vboxCredits.setVisible(false);
			this.vboxInfo.setVisible(true);
		}
		else
		{
			this.vboxBack.setVisible(false);
			this.vboxTopics.setVisible(false);
			this.vboxInfo.setVisible(false);
			this.vboxMain.setVisible(true);
			this.vboxSettingsInfo.setVisible(true);
		}
		this.vboxQuestions.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxCredits.setVisible(false);
	}
	
	@FXML
	private void changeTheme(ActionEvent event)
	{
		Scene scene = this.vboxMain.getScene();
		ObservableList<String> sheets = scene.getStylesheets();
		
		sheets.add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
		for(String s : sheets)
		{
			if(s.contains("theme"))
				sheets.remove(s);
		}
	}
	
	private void showWarning(Exception e)
	{
		String error;
		
		if(e instanceof java.net.UnknownHostException)
			error = "Host sconosciuto: non è stato possibile connettersi alla repository.";
		else error = e.getClass().getName() + ": " + e.getMessage();
		
		Alert alert = new Alert(AlertType.WARNING);
		alert.setHeaderText("Errore durante il recupero delle informazioni");
		Label l = new Label(error);
		l.setWrapText(true);
		alert.getDialogPane().setContent(l);
		alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
		
		alert.show();
	}
	
	@FXML
	private void checkForQuestionUpdates(ActionEvent event)
	{
		System.out.println("Controllo domande aggiornate...");
		
		boolean res;
		try {
			res = settings.checkQuestionUpdates();
			if(res) // a new version of the questions file was found.
			{
				System.out.println("È stata trovata una versione più recente del file contenente le domande.");
				
				Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
				alert.setTitle("Finestra di dialogo");
				alert.setHeaderText("È stata trovata una versione più recente del file contenente le domande. Scaricarla?");
				alert.setContentText("Questa azione sovrascriverà il file " + SettingsManager.QUESTIONS_FILENAME + " attualmente presente.");
				alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
				alert.showAndWait();
				
				if (alert.getResult() == ButtonType.YES)
				{
					// download "Domande.txt" from the GitHub repository
					if(!QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", "tmp.txt"))
					{
						System.out.println("Errore durante il download del file.");
						
						Alert alert2 = new Alert(AlertType.WARNING, "", ButtonType.OK);
						alert2.setTitle("Warning");
						alert2.setHeaderText("Errore durante il download del file aggiornato");
						alert2.setContentText("Non è stato possibile scaricare il file delle domande aggiornato");
						alert2.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
						alert2.show();
						
						return;
					}
					
					// update Domande.txt with DomandeNew.txt
					new File(SettingsManager.QUESTIONS_FILENAME).delete();
					
					new File("tmp.txt").renameTo(new File(SettingsManager.QUESTIONS_FILENAME));
					
					new File("tmp.txt").delete();
					
					// update settings date
					settings.setQuestionFileDate(settings.getQuestionFileLastUpdate());
					settings.saveSettings(".settings.json");
					
					// update qRepo
					this.qRepo = QuestionRepository.getQuestionRepositoryFromFile(SettingsManager.QUESTIONS_FILENAME);
					
					int qNum = this.qRepo.getQuestions().size();
					this.updateQuestionRepositoryInfo(qNum);
					this.updateSettingsComponents(qNum);
				}
				if (alert.getResult() == ButtonType.NO)
				{
					new File("tmp.txt").delete();
				}
			}
			else
			{
				System.out.println("Non sono state trovate nuove domande.");
				
				Alert alert = new Alert(AlertType.INFORMATION);
				alert.setHeaderText("Non sono state trovate nuove domande.");
				alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
				
				alert.showAndWait();
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			this.showWarning(e);
		}
	}
	
	@FXML
	private void checkForAppUpdates(ActionEvent event)
	{
		System.out.println("Controllo aggiornamenti app...");
		
		boolean res;
		try {
			res = settings.checkAppUpdates();
			if(res) // a new version of the app is available
			{
				System.out.println("È stata trovata una versione più recente dell'app.");
				
				Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
				alert.setTitle("Finestra di dialogo");
				alert.setHeaderText("È stata trovata una versione più recente dell'app. Scaricarla?");
				alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
				
				alert.showAndWait();
				if (alert.getResult() == ButtonType.YES)
				{
					this.hostServices.showDocument("https://github.com/mikyll/ROQuiz/releases/latest");
				}
			}
			else
			{
				System.out.println("Non sono state trovate versioni più recenti dell'app.");
				
				Alert alert = new Alert(AlertType.INFORMATION);
				alert.setHeaderText("Non sono state trovate versioni più recenti dell'app.");
				alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(this.checkBoxDarkTheme.isSelected()));
				
				alert.show();
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
			this.showWarning(e);
		}
	}
	
	@FXML 
	private void saveSettings(ActionEvent event)
	{
		this.saveSettingsChanges();
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML 
	private void cancelSettings(ActionEvent event)
	{
		this.cancelSettingsChanges();
		
		this.vboxBack.setVisible(false);
		this.vboxSettings.setVisible(false);
		this.vboxSettingsInfo.setVisible(true);
		this.vboxMain.setVisible(true);
	}
	
	@FXML
	private void restoreSettings(ActionEvent event)
	{
		System.out.println("Impostazioni predefinite.");
		
		this.spinnerQuestionNumQuiz.getValueFactory().setValue(SettingsManager.DEFAULT_QUESTION_NUMBER);
		this.spinnerTimerMin.getValueFactory().setValue(SettingsManager.DEFAULT_TIMER);
		this.checkBoxShuffleAnswers.setSelected(SettingsManager.DEFAULT_SHUFFLE_ANSWERS);
		this.checkBoxDarkTheme.setSelected(SettingsManager.DEFAULT_DARK_THEME);
		this.checkBoxUpdateQuestions.setSelected(SettingsManager.DEFAULT_CHECK_QUESTIONS_UPDATE);
		this.checkBoxUpdateApp.setSelected(SettingsManager.DEFAULT_CHECK_APP_UPDATE);
		
		this.changeTheme(new ActionEvent());
	}
	
	private void saveSettingsChanges()
	{
		int sqnq, stm;
		boolean sa, dm, cqu, cau;
		sqnq = this.spinnerQuestionNumQuiz.getValue();
		stm = this.spinnerTimerMin.getValue();
		sa = this.checkBoxShuffleAnswers.isSelected();
		dm = this.checkBoxDarkTheme.isSelected();
		cqu = this.checkBoxUpdateQuestions.isSelected();
		cau = this.checkBoxUpdateApp.isSelected();
		
		System.out.println("Modifiche alle impostazioni salvate\nNumero domande per quiz: " +
				sqnq + "\nTimer (minuti): " + stm + "\nRisposte mescolate: " + sa + "\nModalità scura: " + dm
				+ "\nControllo aggiornamento domande: " + cqu + "\nControllo aggiornamenti app: " + cau);
		
		settings.setQuestionNumber(sqnq);
		settings.setTimer(stm);
		settings.setShuffleAnswers(sa);
		settings.setDarkTheme(dm);
		settings.setCheckQuestionsUpdate(cqu);
		settings.setCheckAppUpdate(cau);
		
		if(this.qRepo.hasTopics())
		{
			this.labelSelectedQ.setText("" + this.qRepo.getQuestions().size());
			this.labelQuizQNum.setText("" + sqnq);
			
			for(CheckBox cb : this.checkBoxesTopics)
				cb.setSelected(true);
			this.setDisableCheckBoxes();
		}
		
		this.changeTheme(new ActionEvent());
		
		settings.saveSettings(".settings.json");
	}
	
	private void cancelSettingsChanges()
	{
		System.out.println("Modifiche alle impostazioni annullate.");
		
		this.spinnerQuestionNumQuiz.getValueFactory().setValue(settings.getQuestionNumber());
		this.spinnerTimerMin.getValueFactory().setValue(settings.getTimer());
		this.checkBoxShuffleAnswers.setSelected(settings.isShuffleAnswers());
		this.checkBoxDarkTheme.setSelected(settings.isDarkTheme());
		this.checkBoxUpdateQuestions.setSelected(settings.isCheckQuestionsUpdate());
		this.checkBoxUpdateApp.setSelected(settings.isCheckAppUpdate());
		
		this.changeTheme(new ActionEvent());
	}
	
	@FXML 
	private void openURL(ActionEvent event)
	{
		Hyperlink hl = (Hyperlink) event.getSource();
		
		if(hl.getText().equalsIgnoreCase("mikyll"))
			this.hostServices.showDocument("https://github.com/mikyll");
		else if(hl.getText().equalsIgnoreCase("mikyll/ROQuiz"))
			this.hostServices.showDocument("https://github.com/mikyll/ROQuiz");
		else if(hl.getText().equalsIgnoreCase("Apri una issue"))
			this.hostServices.showDocument("https://github.com/mikyll/ROQuiz/issues/new?title=[Desktop]+Titolo+Problema&body=Descrivi+qui+il+problema%2C+possibilmente+aggiungendo+una+o+pi%C3%B9+etichette.");
		else if(hl.getChildrenUnmodifiable().get(0) instanceof Label)
			this.hostServices.showDocument("https://github.com/mikyll/ROQuiz");
		
		else if(hl.getText().equalsIgnoreCase("TryKatChup"))
			this.hostServices.showDocument("https://github.com/TryKatChup");
		else if(hl.getText().equalsIgnoreCase("Federyeeco"))
			this.hostServices.showDocument("https://github.com/Federicoand98");
		else if(hl.getText().equalsIgnoreCase("LolloFred"))
			this.hostServices.showDocument("https://github.com/lollofred");
		else if(hl.getText().equalsIgnoreCase("filovero98"))
			this.hostServices.showDocument("https://github.com/filippoveronesi");
		else if(hl.getText().equalsIgnoreCase("Icons8"))
			this.hostServices.showDocument("https://icons8.com");
	}
	
	private void initCheckBoxes()
	{
		this.checkBoxesTopics = new ArrayList<CheckBox>();
		
		// check if there are enough questions. In case there aren't, the checkbox are disabled
		int qNum = this.qRepo.getQuestions().size();
		this.labelSelectedQ.setText("" + qNum);
		this.labelQuizQNum.setText("" + settings.getQuestionNumber());
		
		this.vboxCheckBoxes.getChildren().clear();
		for(int i = 0; i < this.qRepo.getTopics().size(); i++) // dynamically generates the hbox containing the checkboxed
		{
			HBox hbox = new HBox();
			hbox.setPrefWidth(350);
			hbox.setPrefHeight(30);
			hbox.setAlignment(Pos.CENTER);
			
			CheckBox cb = new CheckBox();
			cb.setPrefWidth(300);
			cb.setPrefHeight(20);
			cb.setText(this.qRepo.getTopics().get(i) + " (" + this.qRepo.getqNumPerTopics().get(i) + ")");
			cb.setOnAction(this::setTopics);
			cb.setSelected(true);
			
			Button b = new Button();
			b.setId("showQuestions");
			b.setPrefWidth(25);
			b.setPrefHeight(25);
			b.setOnAction(this::showQuestions);
			
			Tooltip t = new Tooltip("Visualizza la lista delle domande per questo argomento");
			t.setFont(Font.font("System", FontWeight.NORMAL, 14.0));
			t.setMaxWidth(400);
			t.setWrapText(true);
			b.setTooltip(t);
			
			this.checkBoxesTopics.add(cb);
			hbox.getChildren().addAll(cb, b);
			
			this.vboxCheckBoxes.getChildren().add(hbox);
		}
		this.setDisableCheckBoxes();
	}
	
	private void setDisableCheckBoxes()
	{
		int qNum = this.qRepo.getQuestions().size();
		for(int i = 0; i < this.checkBoxesTopics.size(); i++)
		{
			boolean disableCheckBox = qNum - this.qRepo.getqNumPerTopics().get(i) < settings.getQuestionNumber(); // disable checkboxes: they won't be deselectable if that would make the question number to be less than the quiz one.
			this.checkBoxesTopics.get(i).setDisable(disableCheckBox);
		}
	}
	
	public void setHostServices(HostServices hostServices)
	{
		this.hostServices = hostServices;
	}
}
