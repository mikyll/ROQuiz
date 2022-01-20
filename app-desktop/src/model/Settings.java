package model;

public class Settings {
	private static int questionNumber;
	private static int timer;
	private static boolean checkQuestionsUpdate;
	private static boolean darkMode;
	
	public Settings() {}
	public Settings(int qNum, int sTime, boolean qUpdate, boolean dMode)
	{
		questionNumber = qNum;
		timer = sTime;
		checkQuestionsUpdate = qUpdate;
		darkMode = dMode;
	}
	
	public int getQuestionNumber() {return questionNumber;}
	public void setQuestionNumber(int qNum) {questionNumber = qNum;}
	public int getTimer() {return timer;}
	public void setTimer(int sTime) {timer = sTime;}
	public boolean isCheckQuestionsUpdate() {return checkQuestionsUpdate;}
	public void setCheckQuestionsUpdate(boolean qUpdate) {checkQuestionsUpdate = qUpdate;}
	public boolean isDarkMode() {return darkMode;}
	public void setDarkMode(boolean dMode) {darkMode = dMode;}
}
