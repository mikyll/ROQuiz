package application;

import java.io.File;

import gui.ControllerMenu;
import persistence.IQuestionRepository;
import persistence.QuestionRepository;
import persistence.SettingsManager;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.layout.AnchorPane;

public class Main extends Application {
	private SettingsManager settings;
	
	/*
	// To load directly the quiz
	@Override
	public void start(Stage stage)
	{
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/gui/ViewQuiz.fxml"));
			AnchorPane quiz = (AnchorPane) loader.load();			
			Scene scene = new Scene(quiz);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			stage.setTitle("ROQuiz");
			stage.setScene(scene);
			stage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}*/
	
	@Override
	public void start(Stage stage)
	{
		System.out.println("ROQuiz v" + SettingsManager.VERSION_NUMBER + "\n");
		
		settings = SettingsManager.getInstance();
		settings.loadSettings(".settings.json");
		
		// load question repository from file
		IQuestionRepository qRepo = QuestionRepository.getQuestionRepositoryFromFile("Domande.txt");
		if(qRepo == null)
		{
			Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
			alert.setTitle("Finestra di dialogo");
			alert.setHeaderText("File domande non valido, riscaricarlo?");
			alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
			alert.showAndWait();
			if (alert.getResult() == ButtonType.YES)
			{
				if(!QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", SettingsManager.QUESTIONS_FILENAME))
				{
					System.out.println("Download file domande fallito");
					System.exit(1);
				}
				
				qRepo = QuestionRepository.getQuestionRepositoryFromFile("Domande.txt");
			}
			if (alert.getResult() == ButtonType.NO)
			{
				new File("tmp.txt").delete();
				System.out.println("File " + SettingsManager.QUESTIONS_FILENAME + " mancante.");
				System.exit(1);
			}
		}
		else
		{
			// check if the automatic "check for updates" setting is selected
			if(settings.isCheckQuestionsUpdate())
			{
				System.out.println("Controllo domande aggiornate...");
				
				// download "Domande.txt" from the GitHub repository
				boolean res = QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", "tmp.txt");
				
				if(res)
				{
					// a new file has been found.
					if(qRepo.isLonger("tmp.txt"))
					{
						System.out.println("È stata trovata una versione più recente del file contenente le domande.");
						
						Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
						alert.setTitle("Finestra di dialogo");
						alert.setHeaderText("È stata trovata una versione più recente del file contenente le domande. Scaricarla?");
						alert.setContentText("Questa azione sovrascriverà il file " + SettingsManager.QUESTIONS_FILENAME + " attualmente presente.");
						alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
						alert.showAndWait();
						
						if (alert.getResult() == ButtonType.YES)
						{
							// update Domande.txt with DomandeNew.txt
							new File(SettingsManager.QUESTIONS_FILENAME).delete();
							
							new File("tmp.txt").renameTo(new File(SettingsManager.QUESTIONS_FILENAME));
						}
						if (alert.getResult() == ButtonType.NO)
						{
							new File("tmp.txt").delete();
						}
					}
					else {
						System.out.println("Non sono state trovate nuove domande.");
					}
				}
				new File("tmp.txt").delete();
			}
		}
		
		// load GUI
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/gui/ViewMenu.fxml"));
			ControllerMenu controller = new ControllerMenu(qRepo);
			controller.setHostServices(this.getHostServices());
			loader.setController(controller);
			AnchorPane menu = (AnchorPane) loader.load();
			Scene scene = new Scene(menu);
			scene.getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
			stage.setTitle("ROQuiz");
			stage.setScene(scene);
			stage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args)
	{
		launch(args);
	}
}