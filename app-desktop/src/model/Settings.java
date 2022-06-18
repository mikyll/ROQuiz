package model;

public class Settings {
	private int questionNumber;
	private int timer;
	private boolean checkQuestionsUpdate;
	private boolean darkTheme;
	
	public Settings() {}
	public Settings(int qNum, int sTime, boolean qUpdate, boolean dTheme)
	{
		this.questionNumber = qNum;
		this.timer = sTime;
		this.checkQuestionsUpdate = qUpdate;
		this.darkTheme = dTheme;
	}
	
	public int getQuestionNumber() {return this.questionNumber;}
	public void setQuestionNumber(int qNum) {this.questionNumber = qNum;}
	public int getTimer() {return this.timer;}
	public void setTimer(int sTime) {this.timer = sTime;}
	public boolean isCheckQuestionsUpdate() {return this.checkQuestionsUpdate;}
	public void setCheckQuestionsUpdate(boolean qUpdate) {this.checkQuestionsUpdate = qUpdate;}
	public boolean isDarkTheme() {return this.darkTheme;}
	public void setDarkTheme(boolean dTheme) {this.darkTheme = dTheme;}
}
