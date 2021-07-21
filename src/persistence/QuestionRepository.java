package persistence;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import model.Question;
import model.Settings;

public class QuestionRepository implements IQuestionRepository {
	
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
				
				this.topics.add(line.substring(1).replaceAll("=+", "").trim());
				
				continue;
			}
			
			if(line.length() > 0 && !line.isBlank()) // next question
			{
				if(this.topicsPresent && line.startsWith("@")) // next topic
				{
					this.qNumPerTopics.add(numPerTopic);
					numPerTopic = 0;
					
					this.topics.add(line.substring(1).replaceAll("=+", "").trim());
					
					line = reader.readLine();
					lineNum++;
				}
				else if(line.startsWith("@"))
					throw new BadFileFormatException(lineNum, "divisione per argomenti non rilevata (non è presente l'argomento per le prime domande), ma ne è stato trovato uno comunque");
				
				Question q = new Question(line);
				
				for(int i = 0; i < Settings.DEFAULT_ANSWER_NUMBER; i++) // answers
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
				if(value < 0 || value > Settings.DEFAULT_ANSWER_NUMBER - 1)
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
				System.out.println(this.topics.get(i) + " (num domande: " + this.qNumPerTopics.get(i) + ")");
			}
		}
	}
	
	@Override
	public List<Question> getQuestions() {return this.questions;}
	public List<String> getTopics() {return topics;}
	public List<Integer> getqNumPerTopics() {return qNumPerTopics;}
	public boolean hasTopics() {return topicsPresent;}
	
	
	
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
