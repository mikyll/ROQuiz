package gui;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.VBox;
import javafx.util.Duration;
import model.Answer;
import model.Question;
import model.Quiz;
import model.Settings;
import persistence.BadFileFormatException;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;

public class ControllerQuiz implements IControllerQuiz{
	private IQuestionRepository qRepo;
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
	
	@FXML private Label labelTimer;
	
	@FXML private VBox vboxResult;
	@FXML private Label labelGivenAnswers;
	@FXML private Label labelCorrectAnswers;
	@FXML private Label labelWrongAnswers;
	
	private Timeline timeline;
	
	// FXML loader call order: Constructor -> initialize(). Inside initialize(), all the fxml object have been already initialized.
	
	public ControllerQuiz()	{}
	
	@FXML @Override 
	public void initialize()
	{		
		// style? Example: remove focus glow on text area and textfields
		
		this.initRadioArray();
		
		try (Reader readerQuiz = new FileReader("Quiz.txt")){
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
		
		this.quiz = new Quiz(this.qRepo.getQuestions(), Settings.DEFAULT_QUESTION_NUMBER);
		this.index = 0;
		this.quizTerminated = false;
		
		// init first question
		this.textQNumber.setText("" + (this.index + 1));
		Question q = this.quiz.getQuestionAt(this.index);
		this.textQuestion.setText(q.getQuestion());
			
		// init first 5 answers
		for(Answer a : this.radioAnswers.keySet())
		{
			this.radioAnswers.get(a).setText(a.toString() + ". " + q.getAnswers().get(a));
		}

		// init timer
		this.timeout = Settings.DEFAULT_TIMER;
		this.timeoutRGB_G = 200;
		this.timeline = new Timeline(new KeyFrame(Duration.millis(1000), ae -> updateTimer()));
		this.timeline.setCycleCount(Settings.DEFAULT_TIMER); // Animation.INDEFINITE for a never ending timer
		this.timeline.play();
		System.out.println("Timer: start");
	}
	
	
	@FXML
	public void setAnswer(ActionEvent event)
	{
		String answer = event.getSource().toString().substring(20, 21);
		this.quiz.setAnswer(this.index, Answer.valueOf(answer));
		
		System.out.println("Question " + (this.index+1) + ": selected answer " + answer + ".");
	}
	
	@FXML @Override 
	public void previousQuestion(ActionEvent event)
	{
		this.index--;
		if(this.index == Settings.DEFAULT_QUESTION_NUMBER - 2)
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
		if(this.index == Settings.DEFAULT_QUESTION_NUMBER - 1)
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
			if(this.quiz.getGivenAnswers() < Settings.DEFAULT_QUESTION_NUMBER)
			{
				String notAnswered = "";
				for(int i = 0; i < Settings.DEFAULT_QUESTION_NUMBER; i++)
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
		this.quizTerminated = false;
		
		Quiz q = this.quiz;
		
		q.resetQuiz(this.qRepo.getQuestions(), Settings.DEFAULT_QUESTION_NUMBER);
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
		this.timeout = Settings.DEFAULT_TIMER;
		this.timeoutRGB_G = 200;
		this.timeline = new Timeline(new KeyFrame(Duration.millis(1000), ae -> updateTimer()));
		this.timeline.setCycleCount(Settings.DEFAULT_TIMER); // Animation.INDEFINITE for a never ending timer
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
		this.labelGivenAnswers.setText("" + q.getGivenAnswers());
		this.labelCorrectAnswers.setText("" + q.getCorrectAnswers());
		this.labelWrongAnswers.setText("" + (Settings.DEFAULT_QUESTION_NUMBER-q.getCorrectAnswers()));
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
		
		System.out.println("Quiz terminato. Risposte corrette: " + q.getCorrectAnswers() + ", risposte errate: " + (Settings.DEFAULT_QUESTION_NUMBER-q.getCorrectAnswers()));
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
}
