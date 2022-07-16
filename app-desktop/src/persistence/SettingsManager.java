package persistence;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonIOException;
import com.google.gson.JsonSyntaxException;

import model.Settings;

public class SettingsManager {
	public final static String VERSION_NUMBER = "1.5";
	
	private final static String REGEX_DATETIME = "[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T[0-5][0-9]:[0-5][0-9]:[0-5][0-9]Z";
	
	public final static String DEFAULT_QUESTION_FILE_DATE = "1999-01-01T00:00:00Z";
	public final static int DEFAULT_QUESTION_NUMBER = 16;
	public final static int DEFAULT_ANSWER_NUMBER = 5;
	public final static int DEFAULT_TIMER = 18;
	public final static boolean DEFAULT_SHUFFLE_ANSWERS = true;
	public final static boolean DEFAULT_DARK_THEME = false;
	public final static boolean DEFAULT_CHECK_QUESTIONS_UPDATE = true;
	public final static boolean DEFAULT_CHECK_APP_UPDATE = true;
	
	public final static String APP_PATH = "/application/";
	public final static String THEME_LIGHT_FILE = "theme_light.css";
	public final static String THEME_DARK_FILE = "theme_dark.css";
	public final static String QUESTIONS_FILENAME = "Domande.txt";
	
	private static SettingsManager instance = null;
	private static Settings settings;
	
	private static String themeLight;
	private static String themeDark;
	
	private SettingsManager()
	{
		settings = new Settings(DEFAULT_QUESTION_FILE_DATE, DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_DARK_THEME, DEFAULT_SHUFFLE_ANSWERS, DEFAULT_CHECK_APP_UPDATE);
		
		themeLight = getClass().getResource(APP_PATH + THEME_LIGHT_FILE).toExternalForm();
		themeDark = getClass().getResource(APP_PATH + THEME_DARK_FILE).toExternalForm();
	}

	public static synchronized SettingsManager getInstance()
	{
		if(instance == null)
			instance = new SettingsManager();
		return instance;
	}
	
	public String getQuestionFileDate() {return settings.getQuestionFileDate();}
	public void setQuestionFileDate(String qFDate) {settings.setQuestionFileDate(qFDate);}
	public int getQuestionNumber() {return settings.getQuestionNumber();}
	public void setQuestionNumber(int qNum) {settings.setQuestionNumber(qNum);}
	public int getTimer() {return settings.getTimer();}
	public void setTimer(int sTime) {settings.setTimer(sTime);}
	public boolean isShuffleAnswers() {return settings.isShuffleAnswers();}
	public void setShuffleAnswers(boolean shuffle) {settings.setShuffleAnswers(shuffle);}
	public boolean isDarkTheme() {return settings.isDarkTheme();}
	public void setDarkTheme(boolean dTheme) {settings.setDarkTheme(dTheme);}
	public boolean isCheckQuestionsUpdate() {return settings.isCheckQuestionsUpdate();}
	public void setCheckQuestionsUpdate(boolean qUpdate) {settings.setCheckQuestionsUpdate(qUpdate);}
	public boolean isCheckAppUpdate() {return settings.isCheckAppUpdate();}
	public void setCheckAppUpdate(boolean appUpdate) {settings.setCheckAppUpdate(appUpdate);}
	
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
			
			/*System.out.println("Impostazioni caricate");
			settings.toString();*/
		} catch (NullPointerException | IOException | JsonIOException | JsonSyntaxException e) {
			System.out.println("File delle impostazioni corrotto o assente, verrà ricreato con le impostazioni predefinite.");
			this.resetSettings(filename);
		}
	}
	
	public void saveSettings(Settings s, String filename) {
		try(FileWriter writer = new FileWriter(filename)) {
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(s, writer);
	        
			/*System.out.println("Impostazioni salvate");
	        settings.toString();*/
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
			settings = new Settings(DEFAULT_QUESTION_FILE_DATE, DEFAULT_QUESTION_NUMBER, DEFAULT_TIMER, DEFAULT_SHUFFLE_ANSWERS, DEFAULT_DARK_THEME, DEFAULT_CHECK_QUESTIONS_UPDATE, DEFAULT_CHECK_APP_UPDATE);
			
			Gson gson = new GsonBuilder().excludeFieldsWithModifiers(java.lang.reflect.Modifier.TRANSIENT).setPrettyPrinting().create();
			gson.toJson(settings, writer);
			
			/*System.out.println("Impostazioni predefinite ripristinate");
			settings.toString();*/
		} catch (JsonIOException | IOException e) {
			System.out.println("Errore durante il ripristino del file delle impostazioni.");
			System.exit(1);
		}
	}
	
	public boolean isSettingsValid(int nQuestions)
	{
		boolean result = false;
		
		try {
			String currentFileDate = settings.getQuestionFileDate();
			String nowDate = LocalDateTime.now().toString().substring(0, 19);
			
			result = currentFileDate.matches(REGEX_DATETIME)
					&& Long.parseLong(currentFileDate.replaceAll("[-|T|:|Z]", "")) < Long.parseLong(nowDate.replaceAll("[-|T|:|Z]", ""))
					&& settings.getQuestionNumber() >= 8 && settings.getQuestionNumber() <= nQuestions
					&& settings.getTimer() >= 9 && settings.getTimer() <= nQuestions * 2;
		} catch(Exception e) {}
		
		return result;
	}
	
	public static String getStyle(boolean dark)
	{
		String result;
		
		if(dark)
			result = themeDark;
		else result = themeLight;
		
		return result;
	}
	
	public boolean checkQuestionUpdates() throws Exception
	{
		boolean result = false;
		
		String fromRepository = this.getQuestionFileLastUpdate();
		String currentDate = settings.getQuestionFileDate();
		
		if(this.compareDates(currentDate, fromRepository) == 1)
			result = true;
		
		return result;
	}
	
	public boolean checkAppUpdates() throws Exception
	{
		String url, latestVersion;
		int currentV, latestV;
		boolean result = false;
		
		url = "https://api.github.com/repos/mikyll/ROQuiz/releases/latest";
		latestVersion = VERSION_NUMBER;

		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("Content-type", "application/json").build();
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		
		String json = response.body();
		
		int iStart, iEnd;
		iStart = json.indexOf("tag_name") + 12;
		json = json.substring(iStart);
		iEnd = json.indexOf("\"");
		latestVersion = json.substring(0, iEnd);
		
		try {
			currentV = Integer.parseInt(VERSION_NUMBER.replaceAll("\\.", ""));
			latestV = Integer.parseInt(latestVersion.replaceAll("\\.", ""));
			
			if(currentV < latestV)
			{
				result = true;
			}
		} catch(NumberFormatException e) {}
		
		return result;
	}
	
	public String getQuestionFileLastUpdate() throws Exception
	{
		String url;
		String result = "ERROR";
		
		url = "https://api.github.com/repos/mikyll/ROQuiz/commits?path=Domande.txt&page=1&per_page=1";
		
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).header("Content-type", "application/json").build();
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		
		String json = response.body();
		
		int iStart, iEnd;
		iStart = json.indexOf("date") + 7;
		json = json.substring(iStart);
		iEnd = json.indexOf("\"");
		result = json.substring(0, iEnd);
		
		return result;
	}
	
	/*
	 * Compares date1 with date2
	 * 
	 * @return -1 if date1 > date2
	 */
	private int compareDates(String date1, String date2)
	{
		long d1, d2;
		int result = -1;
		
		try {
			d1 = Long.parseLong(date1.replaceAll("[-|T|:|Z]", ""));
			d2 = Long.parseLong(date2.replaceAll("[-|T|:|Z]", ""));
			
			if(d1 > d2)
				result = -1;
			else if(d1 == d2)
				result = 0;
			else result = 1;
		}
		catch (Exception e) {}
		
		return result;
	}
	
	public boolean equals(Settings s)
	{
		return (s.getQuestionNumber() == getQuestionNumber() &&
				s.getTimer() == getTimer() &&
				s.isShuffleAnswers() == isShuffleAnswers() &&
				s.isDarkTheme() == isDarkTheme() &&
				s.isCheckQuestionsUpdate() == isCheckQuestionsUpdate());
	}
}
