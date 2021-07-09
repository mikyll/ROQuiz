package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public class Quiz {
	private List<Question> quiz;
	private List<Answer> answers; // user answers
	private int correctAnswers;
	
	public Quiz(List<Question> questions, int qNum)
	{
		this.quiz = new ArrayList<Question>(qNum);
		this.answers = new ArrayList<Answer>(qNum);
		this.correctAnswers = 0;
		
		// init questions
		Collections.shuffle(questions);
		for(int i = 0; i < qNum; i++)
			this.quiz.add(questions.get(i));
		
		// init answers
		for(int i = 0; i < qNum; i++)
			this.answers.add(Answer.NONE);
	}
	
	public Question getQuestionAt(int index) {return this.quiz.get(index);}
	public List<Question> getQuiz() {return this.quiz;}
	public List<Answer> getAnswers() {return this.answers;}
	
	public void setAnswer(int index, int value)
	{
		/*if(value < 1 || value > 5)
			throw new IllegalArgumentException();*/
		this.answers.set(index, Answer.values()[value]);
	}
	public void setAnswer(int index, Answer value)
	{
		/*if(value < 1 || value > 5)
			throw new IllegalArgumentException();*/
		this.answers.set(index, value);
	}
	
	public void resetQuiz(List<Question> questions, int qNum)
	{
		this.quiz = new ArrayList<Question>(qNum);
		Collections.shuffle(questions);
		for(int i = 0; i < qNum; i++)
		{
			this.quiz.add(questions.get(i));
		}
		answers = new ArrayList<Answer>(qNum);
		for(int i = 0; i < qNum; i++)
			this.answers.add(Answer.NONE);
	}
	
	public void checkAnswers()
	{
		for(int i = 0; i < this.quiz.size(); i++)
		{
			Answer ca = this.quiz.get(i).getCorrectAnswer();
			Answer a = this.answers.get(i);
			if(ca.equals(a));
				this.correctAnswers++;
		}
	}
}
