package javafx;

import javafx.event.ActionEvent;

public interface IController {
	void initialize();
	void previousQuestion(ActionEvent event);
	void nextQuestion(ActionEvent event);
	void endResetQuiz();
	void resetQuiz();
	void endQuiz();
}
