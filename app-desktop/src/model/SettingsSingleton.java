package model;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonIOException;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

public class SettingsSingleton {
	public final static double VERSION_NUMBER = 1.3;
	public final static int DEFAULT_QUESTION_NUMBER = 16;
	public final static int DEFAULT_ANSWER_NUMBER = 5;
	public final static int DEFAULT_TIMER = 18;
	public final static boolean DEFAULT_CHECK_QUESTIONS_UPDATE = true;
	public final static boolean DEFAULT_DARK_MODE = false;
	
	private static SettingsSingleton instance = null;
	
	private static boolean justLaunched;
	
	private Settings settings;
	
	private SettingsSingleton()
	{
		justLaunched = true;
		
		settings = new Settings(DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_DARK_MODE);
		
		settings = this.loadSettings(".settings.json");
		
		/*settings = new Settings();
		settings.setQuestionNumber(DEFAULT_QUESTION_NUMBER);
		settings.setAnswerNumber(DEFAULT_ANSWER_NUMBER);
		settings.setTimer(DEFAULT_TIMER);
		settings.setCheckQuestionsUpdate(DEFAULT_CHECK_QUESTIONS_UPDATE);
		settings.setDarkMode(DEFAULT_DARK_MODE);*/
	}

	public static synchronized SettingsSingleton getInstance()
	{
		if(instance == null)
			instance = new SettingsSingleton();
		return instance;
	}

	public boolean isJustLaunched() {return justLaunched;}
	public void setJustLaunched(boolean justLaunched) {SettingsSingleton.justLaunched = justLaunched;}
	
	public int getQuestionNumber() {return this.settings.getQuestionNumber();}
	public void setQuestionNumber(int qNum) {this.settings.setQuestionNumber(qNum);}
	public int getTimer() {return this.settings.getTimer();}
	public void setTimer(int sTime) {this.settings.setTimer(sTime);}
	public boolean isCheckQuestionsUpdate() {return this.settings.isCheckQuestionsUpdate();}
	public void setCheckQuestionsUpdate(boolean qUpdate) {this.settings.setCheckQuestionsUpdate(qUpdate);}
	public boolean isDarkMode() {return this.settings.isDarkMode();}
	public void setDarkMode(boolean dMode) {this.settings.setDarkMode(dMode);}

	public Settings loadSettings(String filename) {
		try {
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).create(); // need this since we use a static class
			JsonReader reader = new JsonReader(new FileReader(filename));
			
			Settings res = new Settings();
			res = gson.fromJson(reader, Settings.class);
			
			System.out.println("Impostazioni caricate\nNumero domande per quiz: " + res.getQuestionNumber() + 
					"\nTimer per quiz (Minuti): " + res.getTimer() + "\nControllo domande aggiornate: " + res.isCheckQuestionsUpdate() +
					"\nTema scuro: " + res.isDarkMode());
			
			return res;
		} catch (NullPointerException | JsonIOException | JsonSyntaxException | FileNotFoundException e) {
			System.out.println("File delle impostazioni corrotto o assente, verrà ricreato con le impostazioni predefinite.");
			this.resetSettings(filename);
			return null;
		}
	}
	
	public void saveSettings(Settings s, String filename) {
		try(FileWriter writer = new FileWriter(filename)) {
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(s, writer);
	        
	        System.out.println("Impostazioni salvate\nNumero domande per quiz: " + settings.getQuestionNumber() + 
					"\nTimer per quiz (Minuti): " + settings.getTimer() + "\nControllo domande aggiornate: " + settings.isCheckQuestionsUpdate() +
					"\nTema scuro: " + settings.isDarkMode());
		} catch (JsonIOException | IOException e) {
			System.out.println("Errore nel salvataggio del file delle impostazioni. Verrà ripristinato.");
			this.resetSettings(filename);
		}
	}
	public void saveSettings(String filename) {
		this.saveSettings(this.settings, filename);
	}
	
	public void resetSettings(String filename) {
		
		try(FileWriter writer = new FileWriter(filename)) {
			Settings s = new Settings(DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_DARK_MODE);
			
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(s, writer);
			
			System.out.println("Impostazioni predefinite ripristinate\nNumero domande per quiz: " + DEFAULT_QUESTION_NUMBER + 
					"\nTimer per quiz (Minuti): " + DEFAULT_TIMER + "\nControllo domande aggiornate: " + DEFAULT_CHECK_QUESTIONS_UPDATE +
					"\nTema scuro: " + DEFAULT_DARK_MODE);
		} catch (JsonIOException | IOException e) {
			System.out.println("Errore durante il ripristino del file delle impostazioni.");
			System.exit(1);
		}
	}
	
	public static void main(String[] args)
	{
		
		SettingsSingleton ss = SettingsSingleton.getInstance();
		Settings s = ss.loadSettings(".settings.json");
		//System.out.println(s.getQuestionNumber());
		
		//ss.resetSettings(".settings.json");
		
		
		
		/*
		System.out.println("ciao");
		Gson gson = new Gson();
		try {
			JsonReader reader = new JsonReader(new FileReader(".settings.json"));
			
			Settings res = new Settings();
			res = gson.fromJson(reader, Settings.class);
			System.out.println(res + ": " + res.getQuestionNumber() + ", " + res.getTimer() + ", " + res.isCheckQuestionsUpdate() + ", " + res.isDarkMode());
			
			Settings prova = new Settings(1, 2, 3, true, true);
			
			gson.toJson(prova, new FileWriter("prova.json"));
			System.out.println("ciao" + gson.toJson(prova).toString());
			
			System.out.println(res + ": " + res.getQuestionNumber() + ", " + res.getTimer() + ", " + res.isCheckQuestionsUpdate() + ", " + res.isDarkMode());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JsonIOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		
	}
}

/*class Settings {
	private static int questionNumber;
	private static int answerNumber;
	private static int timer;
	private static boolean checkQuestionsUpdate;
	private static boolean darkMode;
	
	public Settings() {}
	public Settings(int qNum, int aNum, int sTime, boolean qUpdate, boolean dMode)
	{
		questionNumber = qNum;
		answerNumber = aNum;
		timer = sTime;
		checkQuestionsUpdate = qUpdate;
		darkMode = dMode;
	}
	
	public int getQuestionNumber() {return questionNumber;}
	public void setQuestionNumber(int qNum) {questionNumber = qNum;}
	public int getAnswerNumber() {return answerNumber;}
	public void setAnswerNumber(int aNum) {answerNumber = aNum;}
	public int getTimer() {return timer;}
	public void setTimer(int sTime) {timer = sTime;}
	public boolean isCheckQuestionsUpdate() {return checkQuestionsUpdate;}
	public void setCheckQuestionsUpdate(boolean qUpdate) {checkQuestionsUpdate = qUpdate;}
	public boolean isDarkMode() {return darkMode;}
	public void setDarkMode(boolean dMode) {darkMode = dMode;}
}*/
