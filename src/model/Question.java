package model;

import java.util.ArrayList;
import java.util.List;

public class Question {
	public final static int ANSWER_NUMBER = 5;
	
	private String question;
	private List<String> answers;
	private int correctAnswer;
	
	public Question(String question, List<String> answers, int rightAnswer)
	{
		this.answers = new ArrayList<String>();
		this.question = question;
		this.answers = answers;
		this.correctAnswer = rightAnswer;
	}
	public Question(String question)
	{
		this.answers = new ArrayList<String>();
		this.question = question;
	}

	public String getQuestion() {return question;}
	public void setQuestion(String question) {this.question = question;}
	public List<String> getAnswers() {return answers;}
	public void setAnswers(List<String> answers) {this.answers = answers;}
	public int getCorrectAnswer() {return this.correctAnswer;}
	public void setCorrectAnswer(int correctAnswer)
	{
		if(this.correctAnswer >= this.answers.size())
			throw new IllegalArgumentException("Error: the correct answer must be one of answers.");
		this.correctAnswer = correctAnswer;
	}
	public void addAnswer(String answer)
	{
		if(this.answers.size() == ANSWER_NUMBER)
			throw new IllegalArgumentException("Answer number excedeed.");
		this.answers.add(answer);
	}
}
