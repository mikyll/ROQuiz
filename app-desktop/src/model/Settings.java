package model;

public class Settings {
	private int questionNumber;
	private int timer;
	private boolean shuffleAnswers;
	private boolean darkTheme;
	private boolean checkQuestionsUpdate;
	
	public Settings() {}
	public Settings(int qNum, int sTime, boolean shuffle, boolean dTheme, boolean qUpdate)
	{
		this.questionNumber = qNum;
		this.timer = sTime;
		this.shuffleAnswers = shuffle;
		this.darkTheme = dTheme;
		this.checkQuestionsUpdate = qUpdate;
	}
	
	public int getQuestionNumber() {return this.questionNumber;}
	public void setQuestionNumber(int qNum) {this.questionNumber = qNum;}
	public int getTimer() {return this.timer;}
	public void setTimer(int sTime) {this.timer = sTime;}
	public boolean isShuffleAnswers() {return this.shuffleAnswers;}
	public void setShuffleAnswers(boolean shuffleAnswers) {this.shuffleAnswers = shuffleAnswers;}
	public boolean isDarkTheme() {return this.darkTheme;}
	public void setDarkTheme(boolean dTheme) {this.darkTheme = dTheme;}
	public boolean isCheckQuestionsUpdate() {return this.checkQuestionsUpdate;}
	public void setCheckQuestionsUpdate(boolean qUpdate) {this.checkQuestionsUpdate = qUpdate;}
}
