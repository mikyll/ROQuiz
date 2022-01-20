package persistence;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import model.Question;
import model.SettingsSingleton;

public class QuestionRepository implements IQuestionRepository {
	private static final String regexTopic = "[^a-zA-ZÀ-ÿ\\s]+";
	
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
			
			if(lineNum == 1 && line.startsWith("@")) // if the first line is a topic, we know the questions are divided by subject (the topics)
			{
				this.topicsPresent = true;
				
				this.topics = new ArrayList<String>();
				this.qNumPerTopics = new ArrayList<Integer>();
				
				this.topics.add(line.substring(1).replaceAll(regexTopic, "").trim());
				
				continue;
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
				
				for(int i = 0; i < SettingsSingleton.DEFAULT_ANSWER_NUMBER; i++) // answers
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
				if(value < 0 || value > SettingsSingleton.DEFAULT_ANSWER_NUMBER - 1)
					throw new BadFileFormatException(lineNum, "risposta corretta");
				
				q.setCorrectAnswer(value);
				
				questions.add(q);
				
				if(this.topicsPresent)
					numPerTopic++;
			}
			else continue;
			
		}
		System.out.println("Domande lette dal file: " + totQuest);
		if(this.topicsPresent)
		{
			System.out.println("Argomenti:");
			this.qNumPerTopics.add(numPerTopic);
			
			for(int i = 0; i < this.qNumPerTopics.size(); i++)
			{
				System.out.println("-" + this.topics.get(i) + " (num domande: " + this.qNumPerTopics.get(i) + ")");
			}
		}
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
			return false;
		}
	}
	
	// check which file is longer. -1 file1 is longer, 0 they're equal, 1 file2 is longer.
	public static int compareFilesLength(String filename1, String filename2)
	{
		try (BufferedReader br1 = new BufferedReader(new InputStreamReader(new FileInputStream(filename1), StandardCharsets.ISO_8859_1));
				BufferedReader br2 = new BufferedReader(new InputStreamReader(new FileInputStream(filename2), StandardCharsets.ISO_8859_1))){
			
			String line1, line2;
			while ((line1 = br1.readLine()) != null)
			{
				line2 = br2.readLine();
				if (line2 == null)
					return -1;
			}
			if (br2.readLine() == null) {
				return 0;
			}
			else return 1;
		} catch(IOException e) {
			System.out.println("Errore: " + e.getMessage());
			return 1;
		}
	}
	
	// test main
	/*public static void main(String args[]) throws BadFileFormatException
	{
		QuestionRepository qr = null;
		try (Reader readerQuiz = new FileReader("QuizDivisiPerArgomento.txt");) {
			qr = new QuestionRepository(readerQuiz);
		} catch (IOException e) {
			System.out.println("Errore");
		}
		
		System.out.println("Num Question: " + qr.getQuestions().size());
		
		Quiz q = new Quiz(qr.getQuestions(), 3);
		for(Question question : q.getQuiz())
			qr.printQuestion(question);
	}
	public void printEachQuestion()
	{
		int i = 0;
		for(Question q : this.questions)
		{
			System.out.print("\n" + i + ") ");
			printQuestion(q);
			
			i++;
		}
	}
	public void printQuestion(Question q)
	{
		System.out.println(q.getQuestion());
		for(Answer a : q.getAnswers().keySet())
		{
			System.out.println(a.toString() + ". " + q.getAnswers().get(a));
		}
		System.out.println("Correct answer: " + q.getCorrectAnswer());
	}*/
}
