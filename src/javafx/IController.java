package javafx;

import java.util.List;

import javafx.event.ActionEvent;
import model.Question;

public interface IController {
	int checkQuestions(Question q, int answer);
	void previousQuestion(ActionEvent event);
	void nextQuestion(ActionEvent event);
	void endQuiz();
}
