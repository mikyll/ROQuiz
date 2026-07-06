package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Quiz {
	private List<Question> quiz;
	private List<Answer> answers; // user answers
	private int givenAnswers;
	private int correctAnswers;
		
	public Quiz(List<Question> questions, int qNum, boolean shuffleAnswers)
	{
		this.resetQuiz(questions, qNum, shuffleAnswers);
	}
	
	public Question getQuestionAt(int index) {return this.quiz.get(index);}
	public List<Question> getQuiz() {return this.quiz;}
	public List<Answer> getAnswers() {return this.answers;}
	public int getGivenAnswers() {return givenAnswers;}
	public int getCorrectAnswers() {return correctAnswers;}
	
	public void setAnswer(int index, int value)
	{
		/*if(value < 0 || value > Settings.ANSWER_NUMBER - 1)
			throw new IllegalArgumentException();*/
		if(this.answers.get(index).equals(Answer.NONE))
			this.givenAnswers++;
		
		this.answers.set(index, Answer.values()[value]);
	}
	public void setAnswer(int index, Answer value)
	{
		/*if(value < 0 || value > Settings.ANSWER_NUMBER - 1)
			throw new IllegalArgumentException();*/
		if(this.answers.get(index).equals(Answer.NONE))
			this.givenAnswers++;
		
		this.answers.set(index, value);
	}
	
	public void resetQuiz(List<Question> questions, int qNum, boolean shuffleAnswers)
	{
		// reset questions & user answers
		this.quiz = new ArrayList<Question>(qNum);
		this.answers = new ArrayList<Answer>(qNum);
		
		Collections.shuffle(questions);
		for(int i = 0; i < qNum; i++)
		{
			Question q = questions.get(i);
			
			if(shuffleAnswers)
				q.shuffleAnswers();
			
			this.quiz.add(q);
			this.answers.add(Answer.NONE);
		}
		
		// reset counters
		this.givenAnswers = 0;
		this.correctAnswers = 0;
	}
	
	public void checkAnswers()
	{
		for(int i = 0; i < this.quiz.size(); i++)
		{
			Answer ca = this.quiz.get(i).getCorrectAnswer();
			Answer ua = this.answers.get(i);
			
			if(ca.equals(ua))
				this.correctAnswers++;
		}
	}
}
