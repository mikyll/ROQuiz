package controller;

import java.util.ArrayList;
import java.util.List;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.RadioButton;
import model.Question;
import persistenece.IQuestionRepository;

public class Controller implements IController{
	private IQuestionRepository qRepo;
	private int index;
	private List<Integer> userAnswers;
	
	@FXML private RadioButton radioA1;
	@FXML private RadioButton radioA2;
	@FXML private RadioButton radioA3;
	@FXML private RadioButton radioA4;
	@FXML private RadioButton radioA5;
	
	@FXML private Button buttonPrev;
	@FXML private Button buttonNext;
	@FXML private Button buttonEnd;
	
	public Controller(IQuestionRepository quizRepository)
	{
		this.qRepo = quizRepository;
		this.userAnswers = new ArrayList<Integer>();
		this.index = 1;
	}
	
	
	
	@Override
	public int checkQuestions(Question q, int answer) {
		return 0; // return array of correct answers
	}

	@Override
	public void previousQuestion() {
		this.index--;
	}

	@Override
	public void nextQuestion() {
		this.index++;
	}

	@Override
	public void endQuiz() {
		// blocca timer, salva risposte (radio button non modificabili)
	}



	@Override
	public void generateQuiz() {
		// TODO Auto-generated method stub
		
	}
	
	
}
