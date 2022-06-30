package persistence;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

import model.Question;

public class QuestionRepository implements IQuestionRepository {
	public static final Charset questionsEncoding = StandardCharsets.UTF_8;
	
	private static final String regexTopic = "[^a-zA-ZÀ-ÿ\\s]+";
	
	private LocalDate lastUpdate;
	private int fileLength;
	
	private List<Question> questions;
	private List<String> topics;
	private List<Integer> qNumPerTopics;
	private boolean topicsPresent;
	
	public QuestionRepository(Reader baseReader) throws IOException, BadFileFormatException
	{
		if(baseReader == null)
			throw new IllegalArgumentException("Null Reader");
		
		this.questions = new ArrayList<Question>();
		
		BufferedReader reader = new BufferedReader(baseReader);
		
		int lineNum = 0, numPerTopic = 0, totQuest = 0;
		String line = null;
		
		while ((line = reader.readLine()) != null)
		{
			lineNum++;
			line.trim();
			
			if(lineNum == 1)
			{
				if(line.startsWith("#")) // last update date is present
				{
					// read date
					lastUpdate = LocalDate.parse(line.replace("#", ""));
					
					lineNum++;
					if((line = reader.readLine()) == null)
						throw new BadFileFormatException(lineNum, "il file è troppo corto");
				}
				if(line.startsWith("@"))
				{
					this.topicsPresent = true;
					
					this.topics = new ArrayList<String>();
					this.qNumPerTopics = new ArrayList<Integer>();
					
					this.topics.add(line.substring(1).replaceAll(regexTopic, "").trim());
					
					continue;
				}
			}
			
			if(line.length() > 0 && !line.isBlank()) // next question
			{
				if(this.topicsPresent && line.startsWith("@")) // next topic
				{
					this.qNumPerTopics.add(numPerTopic);
					numPerTopic = 0;
					
					this.topics.add(line.substring(1).replaceAll(regexTopic, "").trim());
					
					line = reader.readLine();
					lineNum++;
				}
				else if(line.startsWith("@"))
					throw new BadFileFormatException(lineNum, "divisione per argomenti non rilevata (non è presente l'argomento per le prime domande), ma ne è stato trovato uno comunque");
				
				Question q = new Question(line);
				
				for(int i = 0; i < SettingsManager.DEFAULT_ANSWER_NUMBER; i++) // answers
				{
					line = reader.readLine();
					lineNum++;
					
					String splitted[] = line.split("\\. ");
					if(splitted.length < 2 || splitted[1].isEmpty() || splitted[1].isBlank()) // answer missing or empty
						throw new BadFileFormatException(lineNum, "risposta " + String.valueOf((char) (i+65)));
										
					q.addAnswer(splitted[1]);
				}
				
				line = reader.readLine(); // correct answer
				lineNum++;
				totQuest++;
				
				if(line.length() != 1 || line.isBlank())
					throw new BadFileFormatException(lineNum, "risposta corretta");
				
				char ch = line.toCharArray()[0];
				int value = ((int) ch) - 65;
				if(value < 0 || value > SettingsManager.DEFAULT_ANSWER_NUMBER - 1)
					throw new BadFileFormatException(lineNum, "risposta corretta");
				
				q.setCorrectAnswer(value);
				
				questions.add(q);
				
				if(this.topicsPresent)
					numPerTopic++;
			}
			else continue;
			
		}
		fileLength = lineNum;
		
		System.out.println("Domande lette dal file: " + totQuest);
		if(this.topicsPresent)
		{
			this.qNumPerTopics.add(numPerTopic);
			
			/*System.out.println("Argomenti:");
			for(int i = 0; i < this.qNumPerTopics.size(); i++)
			{
				System.out.println("-" + this.topics.get(i) + " (num domande: " + this.qNumPerTopics.get(i) + ")");
			}*/
		}
	}
	
	public static QuestionRepository getQuestionRepositoryFromFile(String filename)
	{
		QuestionRepository result = null;

		try (BufferedReader readerQuestions= new BufferedReader(new InputStreamReader(new FileInputStream(filename), questionsEncoding))){
			result = new QuestionRepository(readerQuestions);
		} catch (FileNotFoundException e) {
			System.out.println("File '" + filename + "' mancante.");
			result = null;
		} catch (IOException e) {
			System.out.println("Errore nella lettura del file '" + filename + "'");
			result = null;
		} catch (BadFileFormatException e) {
			System.out.println("Errore nella formattazione del file '" + filename + "': " + e.getMessage() + " (linea " + e.getExceptionLine() + ")");
			result = null;
		}
		
		return result;
	}
	
	@Override
	public List<Question> getQuestions() {return this.questions;}
	public List<String> getTopics() {return topics;}
	public List<Integer> getqNumPerTopics() {return qNumPerTopics;}
	public boolean hasTopics() {return topicsPresent;}
	
	public static boolean downloadFile(String url, String filename)
	{
		try (BufferedInputStream in = new BufferedInputStream(new URL(url).openStream());
				FileOutputStream fileOutputStream = new FileOutputStream(filename)){
			byte dataBuffer[] = new byte[1024];
			
			int bytesRead;
			while ((bytesRead = in.read(dataBuffer, 0, 1024)) != -1)
			{
				fileOutputStream.write(dataBuffer, 0, bytesRead);
			}
			
			return true;
		} catch (IOException e) {
			System.out.println("Errore durante il controllo delle domande aggiornate: " + e.getMessage());
			//e.printStackTrace();
			return false;
		}
	}
	
	// check which file is longer. -1 file1 is longer, 0 they're equal, 1 file2 is longer.
	public boolean isLonger(String filename)
	{
		boolean result = false;
		
		try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(filename), questionsEncoding))) {
			int lineNum = 0;
			
			while ((br.readLine()) != null)
			{
				lineNum++;
			}
			
			if (lineNum > this.fileLength)
				result = true;
		} catch(IOException e) {
			System.out.println("Errore: " + e.getMessage());
			result = false;
		}
		
		return result;
	}
	
	public int compareDate(String filename)
	{
		int result = -1;
		try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(filename), questionsEncoding))) {
			
			String line;
			if ((line = br.readLine()) == null)
			{
				return -1;
			}
			
			LocalDate ld = LocalDate.parse(line.replace("#", line));
			if(ld.isAfter(this.lastUpdate))
				result = 1;
			if(ld.isEqual(this.lastUpdate))
				result = 0;
			if(ld.isBefore(this.lastUpdate))
				result = -1;
			
		} catch(IOException e) {
			System.out.println("Errore: " + e.getMessage());
			result = -1;
		} catch(DateTimeParseException e) {
			System.out.println("Il file scaricato non contiene la data. Errore: " + e.getMessage());
			result = -1;
		}
		return result;
	}
}
