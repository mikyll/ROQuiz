package persistenece;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import model.Answer;
import model.Question;
import model.Quiz;

public class QuestionRepository implements IQuestionRepository {
	public final static int ANSWER_NUMBER = 5;
	
	private List<Question> questions;
	
	public QuestionRepository(Reader baseReader) throws IOException, BadFileFormatException
	{
		if(baseReader == null)
			throw new IllegalArgumentException("Null Reader");
		
		questions = new ArrayList<Question>();
		
		BufferedReader reader = new BufferedReader(baseReader);
		
		int nLine = 0;
		String line = null;
		while ((line = reader.readLine()) != null)
		{
			nLine++;
			line.trim();
			
			if(line.length() > 0) // next question
			{
				Question q = new Question(line);
				nLine++;
				//System.out.println(line); // test
				
				for(int i = 0; i < ANSWER_NUMBER; i++) // answers
				{
					line = reader.readLine();
					nLine++;
					line = line.split("\\. ")[1]; // ADD CHECK SPLIT
					
					q.addAnswer(line); // ADD BAD FILE FORMAT EXCEPTION (+ LINE NUMBER)
					
					//System.out.println(line); // test
				}
				
				line = reader.readLine(); // correct answer
				nLine++;
				
				char ch = line.toCharArray()[0];
				int value = ((int) ch) - 65;
				if(value < 0 || value > 4) // ADD BETTER CHECK
				{
					System.out.println("ERRORE");
					return;
				}
				
				q.setCorrectAnswer(value);
				
				//System.out.println(line); // test
				
				try
				{
					
				} catch(IllegalArgumentException e)
				{
					System.out.println("Errore in riga " + nLine);
				}
				
				questions.add(q);
			}
			else continue;
			
		}
	}
	
	public void duplicateCheck()
	{
		
	}
	
	// test
	public static void main(String args[]) throws BadFileFormatException
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
		
		/*System.out.println("culo");
		qr.printEachQuestion();*/
	}
	
	@Override
	public List<Question> getQuestions() {return this.questions;}
	public Question getQuestion(int id)
	{
		return this.questions.get(id);
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
	}
}
