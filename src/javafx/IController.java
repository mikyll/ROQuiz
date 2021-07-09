package javafx;

import javafx.event.ActionEvent;

public interface IController {
	void previousQuestion(ActionEvent event);
	void nextQuestion(ActionEvent event);
	void endResetQuiz();
}
