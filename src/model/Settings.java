package model;

public class Settings {
	public final static double VERSION_NUMBER = 1.2;
	public final static int DEFAULT_QUESTION_NUMBER = 16;
	public final static int DEFAULT_ANSWER_NUMBER = 5;
	public final static int DEFAULT_START_TIME = 60;
	
	private static Settings instance = null;
	
	private static int questionNumber;
	private static int answerNumber;
	private static int startTime;
	
	private Settings()
	{
		questionNumber = DEFAULT_QUESTION_NUMBER;
		answerNumber = DEFAULT_ANSWER_NUMBER;
		startTime = DEFAULT_START_TIME;
	}
	
	public static synchronized Settings getInstance()
	{
		if(instance == null)
			instance = new Settings();
		return instance;
	}

	public int getQuestionNumber() {return questionNumber;}
	public void setQuestionNumber(int qNum) {questionNumber = qNum;}
	public int getAnswerNumber() {return answerNumber;}
	public void setAnswerNumber(int aNum) {answerNumber = aNum;}
	public int getStartTime() {return startTime;}
	public void setStartTime(int sTime) {startTime = sTime;}
}
