package model;

import java.util.HashMap;

public class Question {	
	private String question;
	private HashMap<Answer, String> answers;
	private Answer correctAnswer;
	
	public Question(String question)
	{
		this.answers = new HashMap<Answer, String>(Settings.DEFAULT_ANSWER_NUMBER);
		this.question = question;
	}

	public String getQuestion() {return question;}
	public void setQuestion(String question) {this.question = question;}
	public HashMap<Answer, String> getAnswers() {return answers;}
	public void setAnswers(HashMap<Answer, String> answers) {this.answers = answers;}
	public void addAnswer(String answer)
	{
		if(this.answers.keySet().size() == Settings.DEFAULT_ANSWER_NUMBER)
			throw new IllegalArgumentException("Answer number excedeed.");
		
		int index = this.answers.keySet().size();
		Answer a = Answer.values()[index];
		this.answers.put(a, answer);
	}
	public Answer getCorrectAnswer() {return this.correctAnswer;}
	public void setCorrectAnswer(int correctAnswer)
	{
		if(correctAnswer > Settings.DEFAULT_ANSWER_NUMBER)
			throw new IllegalArgumentException("Error: the correct answer must be one of answers.");
		this.correctAnswer = Answer.values()[correctAnswer];
	}
	public void setCorrectAnswer(Answer correctAnswer)
	{
		this.correctAnswer = correctAnswer;
	}
	
}
