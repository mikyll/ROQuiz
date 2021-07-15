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
	
	public QuestionRepository(Reader baseReader) throws IOException, BadFileFormatException
	{
		if(baseReader == null)
			throw new IllegalArgumentException("Null Reader");
		
		questions = new ArrayList<Question>();
		
		BufferedReader reader = new BufferedReader(baseReader);
		
		int lineNum = 0, questNum = 0;
		String line = null;
		while ((line = reader.readLine()) != null)
		{
			lineNum++;
			line.trim();
			
			if(line.length() > 0 && !line.isBlank()) // next question
			{
				/*if(line.startsWith("@")) // add topic check ?
					// add topic*/
				
				Question q = new Question(line);
				
				for(int i = 0; i < Settings.ANSWER_NUMBER; i++) // answers
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
				questNum++;
				
				if(line.length() != 1 || line.isBlank())
					throw new BadFileFormatException(lineNum, "risposta corretta");
				
				char ch = line.toCharArray()[0];
				int value = ((int) ch) - 65;
				if(value < 0 || value > Settings.ANSWER_NUMBER - 1)
					throw new BadFileFormatException(lineNum, "risposta corretta");
				
				q.setCorrectAnswer(value);
				
				questions.add(q);
			}
			else continue;
			
		}
		System.out.println("Domande lette dal file: " + questNum);
	}
	
	@Override
	public List<Question> getQuestions() {return this.questions;}
	public Question getQuestion(int id)
	{
		return this.questions.get(id);
	}
	
	// test main
	/*public static void main(String args[]) throws BadFileFormatException
	{
		QuestionRepository qr = null;
		try (Reader readerQuiz = new FileReader("Quiz.txt");) {
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
