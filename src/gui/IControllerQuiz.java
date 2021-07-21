package gui;

import javafx.event.ActionEvent;

public interface IControllerQuiz {
	void initialize();
	void previousQuestion(ActionEvent event);
	void nextQuestion(ActionEvent event);
	void endResetQuiz();
	void resetQuiz();
	void endQuiz();
}
