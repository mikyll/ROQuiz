package persistence;

import java.util.List;

import model.Question;

public interface IQuestionRepository {
	public List<Question> getQuestions(); 
	public List<String> getTopics();
	public List<Integer> getqNumPerTopics();
	public boolean hasTopics();
}
