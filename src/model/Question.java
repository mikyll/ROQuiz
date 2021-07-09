package model;

import java.util.HashMap;

public class Question {
	public final static int ANSWER_NUMBER = 5;
	
	private String question;
	private HashMap<Answer, String> answers;
	private Answer correctAnswer;
	
	/*public Question(String question, List<String> answers, int rightAnswer)
	{
		this.answers = new HashMap<Answer, String>(5);
		this.question = question;
		for(Answer a : )
		this.correctAnswer = Answer.values()[rightAnswer];
	}
	public Question(String question, List<String> answers, Answer rightAnswer)
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
	}*/
	public Question(String question)
	{
		this.answers = new HashMap<Answer, String>(5);
		this.question = question;
	}

	public String getQuestion() {return question;}
	public void setQuestion(String question) {this.question = question;}
	public HashMap<Answer, String> getAnswers() {return answers;}
	public void setAnswers(HashMap<Answer, String> answers) {this.answers = answers;}
	public void addAnswer(String answer)
	{
		if(this.answers.keySet().size() == ANSWER_NUMBER)
			throw new IllegalArgumentException("Answer number excedeed.");
		
		int index = this.answers.keySet().size();
		Answer a = Answer.values()[index];
		this.answers.put(a, answer);
	}
	public Answer getCorrectAnswer() {return this.correctAnswer;}
	public void setCorrectAnswer(int correctAnswer)
	{
		if(correctAnswer > 5)
			throw new IllegalArgumentException("Error: the correct answer must be one of answers.");
		this.correctAnswer = Answer.values()[correctAnswer];
	}
	public void setCorrectAnswer(Answer correctAnswer)
	{
		this.correctAnswer = correctAnswer;
	}
	
}
