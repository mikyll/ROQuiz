package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public class Quiz {
	private List<Question> quiz;
	private int[] answers;
	
	public Quiz(List<Question> questions, int qNum)
	{
		this.quiz = new ArrayList<Question>();
		
		Collections.shuffle(questions);
		for(int i = 0; i < qNum; i++)
		{
			this.quiz.add(questions.get(i));
		}
		answers = new int[qNum];
		for(int i : answers)
			i = -1;
	}
	
	public List<Question> getQuiz() {return this.quiz;}
	public int[] getAnswers() {return this.answers;}
	
	public void setAnswer(int index, int value)
	{
		/*if(value < 1 || value > 5)
			throw new IllegalArgumentException();*/
		this.answers[index] = value;
	}
	
	public void resetQuiz(List<Question> questions, int qNum)
	{
		this.quiz = new ArrayList<Question>();
		Collections.shuffle(questions);
		for(int i = 0; i < qNum; i++)
		{
			this.quiz.add(questions.get(i));
		}
		answers = new int[qNum];
		for(int i : answers)
			i = -1;
	}
}
