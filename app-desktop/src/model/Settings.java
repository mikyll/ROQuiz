package model;

public class Settings {
	private String questionFileDate;
	private int questionNumber;
	private int timer;
	private boolean shuffleAnswers;
	private boolean darkTheme;
	private boolean checkQuestionsUpdate;
	private boolean checkAppUpdate;
	
	public Settings() {}
	public Settings(String qFDate, int qNum, int sTime, boolean shuffle, boolean dTheme, boolean qUpdate, boolean appUpdate)
	{
		this.questionFileDate = qFDate;
		this.questionNumber = qNum;
		this.timer = sTime;
		this.shuffleAnswers = shuffle;
		this.darkTheme = dTheme;
		this.checkQuestionsUpdate = qUpdate;
		this.checkAppUpdate = appUpdate;
	}
	
	public String getQuestionFileDate() {return this.questionFileDate;}
	public void setQuestionFileDate(String qFDate) {this.questionFileDate = qFDate;}
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
	public boolean isCheckAppUpdate() {return this.checkAppUpdate;}
	public void setCheckAppUpdate(boolean appUpdate) {this.checkAppUpdate = appUpdate;}
	
	public String toString()
	{
		return	"Data file domande: " + this.questionFileDate +
				"\nNumero domande per quiz: " + this.questionNumber + 
				"\nTimer per quiz (Minuti): " + this.timer +
				"\nMescola Risposte: " + this.shuffleAnswers +
				"\nTema scuro: " + this.darkTheme +
				"\nControllo domande aggiornate: " + this.checkQuestionsUpdate +
				"\nControllo aggiornamenti app: " + this.checkAppUpdate;
	}
}
