package javafx;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import model.Answer;
import model.Question;
import model.Quiz;
import persistenece.BadFileFormatException;
import persistenece.IQuestionRepository;
import persistenece.QuestionRepository;

public class Controller implements IController{
	public final static int QUESTION_NUMBER = 16;
	
	private IQuestionRepository qRepo;
	private Quiz quiz;
	private int index;
	private boolean quizTerminated;
	
	@FXML private TextField textQNumber;
	
	@FXML private TextField textTimer;
	
	@FXML private TextArea textQuestion;
	
	@FXML private RadioButton radioA;
	@FXML private RadioButton radioB;
	@FXML private RadioButton radioC;
	@FXML private RadioButton radioD;
	@FXML private RadioButton radioE;
	private HashMap<Answer, RadioButton> radioAnswers;
	
	@FXML private Button buttonPrev;
	@FXML private Button buttonNext;
	@FXML private Button buttonEnd;
	
	/*public Controller(IQuestionRepository quizRepository)
	{
		this.qRepo = quizRepository;
		this.quiz = new Quiz(this.qRepo.getQuestions(), 16);
		this.index = 0;
	}*/
	
	public Controller()
	{
		
	}
	@FXML public void initialize()
	{		
		// style? Example: remove focus glow on text area and textfields
		
		this.initializeRadioArray();
		
		try (Reader readerQuiz = new FileReader("Quiz.txt")){
			this.qRepo = new QuestionRepository(readerQuiz);
			this.quiz = new Quiz(this.qRepo.getQuestions(), 16);
			this.index = 0;
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (BadFileFormatException e) {
			e.printStackTrace();
		}
		
		for(Answer a : this.quiz.getAnswers())
			System.out.println(a.toString());
		
		this.quizTerminated = false;
		this.index = 0;
				
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
	}
	
	
	
	
	@FXML
	public void setAnswer(ActionEvent event)
	{
		
		String answer = event.getSource().toString().substring(20, 21);
		this.quiz.setAnswer(this.index, Answer.valueOf(answer));
		
		System.out.println("Question " + (this.index+1) + ": selected answer " + answer + ".");
	}
	
	@Override @FXML
	public void previousQuestion(ActionEvent event) {
		this.index--;
		if(this.index == QUESTION_NUMBER - 2)
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

	@Override @FXML
	public void nextQuestion(ActionEvent event) {
		this.index++;
		if(this.index == 1)
			this.buttonPrev.setDisable(false);
		if(this.index == QUESTION_NUMBER - 1)
			this.buttonNext.setDisable(true);
		
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
	
	@Override
	public void endQuiz() {
		this.buttonEnd.setText("Riavvia");
		this.quizTerminated = true;
		
		if(this.quizTerminated)
		{
			Answer ua = this.quiz.getAnswers().get(this.index);
			Answer ca = this.quiz.getQuiz().get(this.index).getCorrectAnswer();
			
			if(ua != null && ua != Answer.NONE)
				this.radioAnswers.get(ua).setStyle("-fx-text-fill: red; -fx-font-weight: bold");
			this.radioAnswers.get(ca).setStyle("-fx-text-fill: rgb(0,200,0); -fx-font-weight: bold");
		}
		
		// test
		for(Answer a : this.quiz.getAnswers())
			System.out.println(a.toString());
		
		this.quiz.checkAnswers();
		// blocca timer, salva risposte (radio button non modificabili)
		
		// confirm prompt?
	}

	
	private void initializeRadioArray()
	{
		this.radioAnswers = new HashMap<Answer, RadioButton>(5);
		this.radioAnswers.put(Answer.A, this.radioA);
		this.radioAnswers.put(Answer.B, this.radioB);
		this.radioAnswers.put(Answer.C, this.radioC);
		this.radioAnswers.put(Answer.D, this.radioD);
		this.radioAnswers.put(Answer.E, this.radioE);
	}
	
	@FXML
	public void prova(ActionEvent event) 
	{
		System.out.println("ciao");
	}
}
