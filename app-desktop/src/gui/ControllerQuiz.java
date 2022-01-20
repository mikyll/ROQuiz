package gui;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.util.Duration;
import model.Answer;
import model.Question;
import model.Quiz;
import model.SettingsSingleton;

public class ControllerQuiz implements IControllerQuiz{
	private List<Question> questions;
	private SettingsSingleton settings;
	private Quiz quiz;
	private int index;
	private boolean quizTerminated;
	private int timeout;
	private int timeoutRGB_G;
	
	@FXML private TextField textQNumber;
	@FXML private TextArea textQuestion;
	
	@FXML private RadioButton radioA;
	@FXML private RadioButton radioB;
	@FXML private RadioButton radioC;
	@FXML private RadioButton radioD;
	@FXML private RadioButton radioE;
	private HashMap<Answer, RadioButton> radioAnswers;
	
	@FXML private Button buttonPrev;
	@FXML private Button buttonNext;
	@FXML private Button buttonEndReset;
	@FXML private Button buttonMenu;
	
	@FXML private Label labelTimer;
	
	@FXML private VBox vboxResult;
	@FXML private Label labelGivenAnswers;
	@FXML private Label labelCorrectAnswers;
	@FXML private Label labelWrongAnswers;
	
	private Timeline timeline;
	
	// FXML loader call order: Constructor -> initialize(). Inside initialize(), all the fxml object have been already initialized.
	public ControllerQuiz(List<Question> questions)
	{
		this.questions = questions;
	}
	
	@FXML @Override 
	public void initialize()
	{
		// style? Example: remove focus glow on text area and textfields
		this.buttonMenu.setVisible(false);
		this.vboxResult.setVisible(false);
		
		this.settings = SettingsSingleton.getInstance();
		this.initRadioArray();
		
		this.quiz = new Quiz(this.questions, this.settings.getQuestionNumber());
		this.index = 0;
		this.quizTerminated = false;
		
		// init first question
		this.textQNumber.setText("" + (this.index + 1));
		Question q = this.quiz.getQuestionAt(this.index);
		this.textQuestion.setText(q.getQuestion());
		this.labelTimer.setText("" + this.settings.getTimer() + ":00");
			
		// init first 5 answers
		for(Answer a : this.radioAnswers.keySet())
		{
			this.radioAnswers.get(a).setText(a.toString() + ". " + q.getAnswers().get(a));
		}

		// init timer
		this.timeout = this.settings.getTimer() * 60;
		this.timeoutRGB_G = 200;
		this.timeline = new Timeline(new KeyFrame(Duration.millis(1000), ae -> updateTimer()));
		this.timeline.setCycleCount(this.settings.getTimer() * 60); // Animation.INDEFINITE for a never ending timer
		this.timeline.play();
		System.out.println("Timer: avviato");
	}
	
	
	@FXML
	public void setAnswer(ActionEvent event)
	{
		String answer = event.getSource().toString().substring(20, 21);
		this.quiz.setAnswer(this.index, Answer.valueOf(answer));
		
		System.out.println("Domanda " + (this.index+1) + ": selezionata la risposta " + answer + ".");
	}
	
	@FXML @Override 
	public void previousQuestion(ActionEvent event)
	{
		this.index--;
		if(this.index == this.settings.getQuestionNumber() - 2)
			this.buttonNext.setDisable(false);
		if(this.index == 0)
			this.buttonPrev.setDisable(true);
		
		// update quiz
		this.textQNumber.setText("" + (this.index + 1));
		Question q = this.quiz.getQuestionAt(this.index);
		
		this.textQuestion.setText(q.getQuestion());
		for(Answer a : this.radioAnswers.keySet())
		{
			this.radioAnswers.get(a).setText(a.toString() + ". " + q.getAnswers().get(a));
			this.radioAnswers.get(a).setStyle("-fx-text-fill: black; -fx-font-weight: normal");
		}
		if(this.quiz.getAnswers().get(this.index) != Answer.NONE)
		{
			Answer a = this.quiz.getAnswers().get(this.index);
			this.radioAnswers.get(a).setSelected(true);
		}
		else
		{
			for(Answer a : this.radioAnswers.keySet())
			{
				this.radioAnswers.get(a).setSelected(false);
			}
		}
		
		if(this.quizTerminated)
		{
			Answer ua = this.quiz.getAnswers().get(this.index);
			Answer ca = this.quiz.getQuiz().get(this.index).getCorrectAnswer();
			
			if(ua != null && ua != Answer.NONE)
				this.radioAnswers.get(ua).setStyle("-fx-text-fill: red; -fx-font-weight: bold");
			this.radioAnswers.get(ca).setStyle("-fx-text-fill: rgb(0,200,0); -fx-font-weight: bold");
		}
	}

	@FXML @Override 
	public void nextQuestion(ActionEvent event)
	{
		this.index++;
		if(this.index == 1)
			this.buttonPrev.setDisable(false);
		if(this.index == this.settings.getQuestionNumber() - 1)
			this.buttonNext.setDisable(true);
		
		// update quiz
		this.textQNumber.setText("" + (this.index + 1));
		Question q = this.quiz.getQuestionAt(this.index);
		
		this.textQuestion.setText(q.getQuestion());
		for(Answer a : this.radioAnswers.keySet())
		{
			RadioButton rb = this.radioAnswers.get(a);
			rb.setText(a.toString() + ". " + q.getAnswers().get(a));
			rb.setStyle("-fx-text-fill: black; -fx-font-weight: normal");
		}
		if(this.quiz.getAnswers().get(this.index) != Answer.NONE)
		{
			Answer a = this.quiz.getAnswers().get(this.index);
			this.radioAnswers.get(a).setSelected(true);
		}
		else
		{
			for(Answer a : this.radioAnswers.keySet())
			{
				this.radioAnswers.get(a).setSelected(false);
			}
		}
		
		if(this.quizTerminated)
		{
			Answer ua = this.quiz.getAnswers().get(this.index);
			Answer ca = this.quiz.getQuiz().get(this.index).getCorrectAnswer();
			
			if(ua != null && ua != Answer.NONE)
				this.radioAnswers.get(ua).setStyle("-fx-text-fill: red; -fx-font-weight: bold");
			this.radioAnswers.get(ca).setStyle("-fx-text-fill: rgb(0,200,0); -fx-font-weight: bold");
		}
	}
	
	@Override
	public void endResetQuiz()
	{
		if(!this.quizTerminated)
		{
			// confirm prompt
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO/*, ButtonType.CANCEL*/);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("Terminare il quiz?");
			if(this.quiz.getGivenAnswers() < this.settings.getQuestionNumber())
			{
				String notAnswered = "";
				for(int i = 0; i < this.settings.getQuestionNumber(); i++)
				{
					if(this.quiz.getAnswers().get(i).equals(Answer.NONE))
						notAnswered += (notAnswered.length() == 0 ? (i+1) : ", " + (i+1));
				}
				alert.setContentText("Non hai risposto alle domande:\n" + notAnswered);
			}
			alert.showAndWait();

			if (alert.getResult() == ButtonType.YES) {
				this.endQuiz();
			}
		}
		else
		{
			this.resetQuiz();
		}
	}

	
	private void initRadioArray()
	{
		this.radioAnswers = new HashMap<Answer, RadioButton>(5);
		this.radioAnswers.put(Answer.A, this.radioA);
		this.radioAnswers.put(Answer.B, this.radioB);
		this.radioAnswers.put(Answer.C, this.radioC);
		this.radioAnswers.put(Answer.D, this.radioD);
		this.radioAnswers.put(Answer.E, this.radioE);
	}
	
	@Override 
	public void resetQuiz()
	{
		this.labelTimer.setText("" + this.settings.getTimer() + ":00");
		this.labelTimer.setStyle("-fx-text-fill: black");
		this.quizTerminated = false;
		
		Quiz q = this.quiz;
		
		q.resetQuiz(this.questions, this.settings.getQuestionNumber());
		this.index = 0;
		
		this.vboxResult.setVisible(false);
		this.buttonEndReset.setText("Termina");
		this.buttonPrev.setDisable(true);
		
		// init first question
		this.textQNumber.setText("" + (this.index + 1));
		Question question = this.quiz.getQuestionAt(this.index);
		this.textQuestion.setText(question.getQuestion());
			
		// init first 5 answers
		for(Answer a : this.radioAnswers.keySet())
		{
			RadioButton rb = this.radioAnswers.get(a);
			rb.setDisable(false);
			rb.setSelected(false);
			rb.setText(a.toString() + ". " + question.getAnswers().get(a));
			rb.setStyle("-fx-text-fill: black; -fx-font-weight: normal");
		}
		
		// start timer
		this.timeout = this.settings.getTimer() * 60;
		this.timeoutRGB_G = 200;
		this.timeline = new Timeline(new KeyFrame(Duration.millis(1000), ae -> updateTimer()));
		this.timeline.setCycleCount(this.settings.getTimer() * 60); // Animation.INDEFINITE for a never ending timer
		this.timeline.play();
		System.out.println("Timer: start");
	}
	
	@Override
	public void endQuiz()
	{
		Quiz q = this.quiz;
		q.checkAnswers();
		this.quizTerminated = true;
		
		this.vboxResult.setVisible(true);
		this.buttonMenu.setVisible(true);
		this.labelGivenAnswers.setText("" + q.getGivenAnswers());
		this.labelCorrectAnswers.setText("" + q.getCorrectAnswers());
		this.labelWrongAnswers.setText("" + (this.settings.getQuestionNumber()-q.getCorrectAnswers()));
		this.buttonEndReset.setText("Riavvia");
		
		for(RadioButton rb : this.radioAnswers.values())
			rb.setDisable(true);
		
		Answer ua = q.getAnswers().get(this.index);
		Answer ca = q.getQuiz().get(this.index).getCorrectAnswer();
			
		if(ua != null && ua != Answer.NONE)
			this.radioAnswers.get(ua).setStyle("-fx-text-fill: red; -fx-font-weight: bold");
		this.radioAnswers.get(ca).setStyle("-fx-text-fill: rgb(0,200,0); -fx-font-weight: bold");
		
		// stop timer
		this.timeline.stop();
		System.out.println("Timer: stop");
		
		System.out.println("Quiz terminato. Risposte corrette: " + q.getCorrectAnswers() + ", risposte errate: " + (this.settings.getQuestionNumber()-q.getCorrectAnswers()));
	}
	
	private void updateTimer()
	{
		this.timeout--;
		
		// color change
		if(this.timeout == 300) // 5 min
			this.labelTimer.setStyle("-fx-text-fill: rgb(235,180,0)");
		if(this.timeout < 300 && this.timeout > 120)
		{
			this.timeoutRGB_G = this.timeoutRGB_G - 1;
			this.labelTimer.setStyle("-fx-text-fill: rgb(235," + this.timeoutRGB_G + ",0)");
		}
		if(this.timeout == 120) // 2 min
			this.labelTimer.setStyle("-fx-text-fill: red");
		
		// timer stop
		if(this.timeout == 0)
		{
			Alert alert = new Alert(AlertType.INFORMATION, "Tempo scaduto.", ButtonType.OK);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("Quiz terminato.");
			alert.show();
			
			this.endQuiz();
		}
		
		// update countdown
		int min = this.timeout / 60;
		int sec = this.timeout % 60;
		String seconds = sec < 10 ? ("0" + sec) : ("" + sec);
		this.labelTimer.setText("" + min + ":" + seconds);
	}
	
	@FXML
	public void selectMenu(ActionEvent event) {
		System.out.println("\nSelezione: menu principale.");
		
		// load
		try {
			FXMLLoader loader = new FXMLLoader(ControllerMenu.class.getResource("/gui/ViewMenu.fxml"));
			Stage stage = (Stage) this.vboxResult.getScene().getWindow();
			// loader.setController(new ControllerMenu());
			AnchorPane menu = (AnchorPane) loader.load();
		
			Scene scene = new Scene(menu);
			scene.getStylesheets().add(ControllerMenu.class.getResource("/application/application.css").toExternalForm());
			stage.setScene(scene);
			stage.show();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ERRORE: " + e.getMessage());
			System.exit(1);
		}
	}
}
