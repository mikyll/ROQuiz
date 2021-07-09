package controller;

import java.util.List;

import model.Question;

public interface IController {
	void generateQuiz();
	int checkQuestions(Question q, int answer);
	void previousQuestion();
	void nextQuestion();
	void endQuiz();
}
