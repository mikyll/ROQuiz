package model;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonIOException;
import com.google.gson.JsonSyntaxException;

public class SettingsSingleton {
	public final static double VERSION_NUMBER = 1.5;
	public final static int DEFAULT_QUESTION_NUMBER = 16;
	public final static int DEFAULT_ANSWER_NUMBER = 5;
	public final static int DEFAULT_TIMER = 18;
	public final static boolean DEFAULT_CHECK_QUESTIONS_UPDATE = true;
	public final static boolean DEFAULT_DARK_MODE = false;
	public final static boolean DEFAULT_SHUFFLE_ANSWERS = true;
	
	private static SettingsSingleton instance = null;
	private static boolean justLaunched;
	private static Settings settings;
	
	private SettingsSingleton()
	{
		justLaunched = true;
		
		settings = new Settings(DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_DARK_MODE, DEFAULT_SHUFFLE_ANSWERS);
	}

	public static synchronized SettingsSingleton getInstance()
	{
		if(instance == null)
			instance = new SettingsSingleton();
		return instance;
	}

	public boolean isJustLaunched() {return justLaunched;}
	public void setJustLaunched(boolean justLaunched) {SettingsSingleton.justLaunched = justLaunched;}
	
	public int getQuestionNumber() {return settings.getQuestionNumber();}
	public void setQuestionNumber(int qNum) {settings.setQuestionNumber(qNum);}
	public int getTimer() {return settings.getTimer();}
	public void setTimer(int sTime) {settings.setTimer(sTime);}
	public boolean isCheckQuestionsUpdate() {return settings.isCheckQuestionsUpdate();}
	public void setCheckQuestionsUpdate(boolean qUpdate) {settings.setCheckQuestionsUpdate(qUpdate);}
	public boolean isDarkTheme() {return settings.isDarkTheme();}
	public void setDarkTheme(boolean dTheme) {settings.setDarkTheme(dTheme);}
	public boolean isShuffleAnswers() {return settings.isShuffleAnswers();}
	public void setShuffleAnswers(boolean shuffle) {settings.setShuffleAnswers(shuffle);}

	public void loadSettings(String filename) {
		try (FileReader reader = new FileReader(filename)) {
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).create(); // need this since we use a static class
			
			settings = gson.fromJson(reader, Settings.class);
			
			// the file exist but it's empty => settings get loaded as null
			if (settings == null)
			{
				System.out.println("File delle impostazioni corrotto, verrà ricreato con le impostazioni predefinite.");
				this.resetSettings(filename);
			}
			
			/*System.out.println("Impostazioni caricate\nNumero domande per quiz: " + this.settings.getQuestionNumber() + 
					"\nTimer per quiz (Minuti): " + this.settings.getTimer() + "\nControllo domande aggiornate: " + this.settings.isCheckQuestionsUpdate() +
					"\nTema scuro: " + this.settings.isDarkMode());*/
			
		} catch (NullPointerException | IOException | JsonIOException | JsonSyntaxException e) {
			System.out.println("File delle impostazioni corrotto o assente, verrà ricreato con le impostazioni predefinite.");
			this.resetSettings(filename);
		}
	}
	
	public void saveSettings(Settings s, String filename) {
		try(FileWriter writer = new FileWriter(filename)) {
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(s, writer);
	        
	        /*System.out.println("Impostazioni salvate\nNumero domande per quiz: " + settings.getQuestionNumber() + 
					"\nTimer per quiz (Minuti): " + settings.getTimer() + "\nControllo domande aggiornate: " + settings.isCheckQuestionsUpdate() +
					"\nTema scuro: " + settings.isDarkMode());*/
		} catch (JsonIOException | IOException e) {
			System.out.println("Errore nel salvataggio del file delle impostazioni. Verrà ripristinato.");
			this.resetSettings(filename);
		}
	}
	public void saveSettings(String filename) {
		this.saveSettings(settings, filename);
	}
	
	public void resetSettings(String filename) {
		
		try(FileWriter writer = new FileWriter(filename)) {
			settings = new Settings(DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_DARK_MODE, DEFAULT_SHUFFLE_ANSWERS);
			
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(settings, writer);
			
			/*System.out.println("Impostazioni predefinite ripristinate\nNumero domande per quiz: " + DEFAULT_QUESTION_NUMBER + 
					"\nTimer per quiz (Minuti): " + DEFAULT_TIMER + "\nControllo domande aggiornate: " + DEFAULT_CHECK_QUESTIONS_UPDATE +
					"\nTema scuro: " + DEFAULT_DARK_MODE);*/
		} catch (JsonIOException | IOException e) {
			System.out.println("Errore durante il ripristino del file delle impostazioni.");
			System.exit(1);
		}
	}
}
