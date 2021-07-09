package javafx;

import java.util.List;

import controller.Controller;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextArea;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.VBox;
import javafx.stage.Window;

public class QuizPane extends AnchorPane {
	public final static int ANSWER_NUMBER = 5;
	
	private Controller controller;
	
	private TextArea question;
	private List<RadioButton> answers;
	
	public QuizPane(Controller controller)
	{
		this.controller = controller;
		initGui();
	}
	
	private void initGui()
	{
		VBox vboxAnswers = new VBox();
		{
			vboxAnswers.setLayoutX(768 / 2);
			vboxAnswers.setLayoutY(480 / 2);
			
			vboxAnswers.getChildren().add(new TextArea());
			
			for(int i = 0; i < ANSWER_NUMBER; i++)
			{
				
			}
		}
	}
}
