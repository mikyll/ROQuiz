package persistence;

import java.util.List;

import model.Question;

public interface IQuestionRepository {
	public List<Question> getQuestions();
}
