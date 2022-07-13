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
	
	@Override
	public void start(Stage stage)
	{
		System.out.println("ROQuiz v" + SettingsManager.VERSION_NUMBER + "\n");
		
		settings = SettingsManager.getInstance();
		settings.loadSettings(".settings.json");
		
		// if automatic "check for app updates" is enabled
		if(settings.isCheckAppUpdate())
		{
			System.out.println("Controllo aggiornamenti app...");
			
			if(settings.checkAppUpdates()) // a new version is available
			{
				System.out.println("È stata trovata una versione più recente dell'app.");
				
				Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
				alert.setTitle("Finestra di dialogo");
				alert.setHeaderText("È stata trovata una versione più recente dell'app. Scaricarla?");
				alert.getDialogPane().getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
				
				alert.showAndWait();
				if (alert.getResult() == ButtonType.YES)
				{
					this.getHostServices().showDocument("https://github.com/mikyll/ROQuiz/releases/latest");
				}
			}
			else
			{
				System.out.println("Non sono state trovate versioni più recenti dell'app.");
			}
		}
		
		// load question repository from file
		IQuestionRepository qRepo = QuestionRepository.getQuestionRepositoryFromFile(SettingsManager.QUESTIONS_FILENAME);
		if(qRepo == null) // questions file missing or not valid
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
				
				qRepo = QuestionRepository.getQuestionRepositoryFromFile(SettingsManager.QUESTIONS_FILENAME);
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
			// if automatic "check for question updates" setting is selected
			if(settings.isCheckQuestionsUpdate())
			{
				System.out.println("Controllo domande aggiornate...");
				
				if(settings.checkQuestionUpdates()) // a new file has been found.
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
						if(!QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", "tmp.txt"))
						{
							System.out.println("Errore durante il download del file.");
							
							Alert alert2 = new Alert(AlertType.WARNING, "", ButtonType.OK);
							alert2.setTitle("Warning");
							alert2.setHeaderText("Errore durante il download del file aggiornato");
							alert2.setContentText("Non è stato possibile scaricare il file delle domande aggiornato");
							alert2.getDialogPane().getStylesheets().add(SettingsManager.getStyle(settings.isDarkTheme()));
							alert2.show();
							
							return;
						}
						
						// update Domande.txt with DomandeNew.txt
						new File(SettingsManager.QUESTIONS_FILENAME).delete();
						
						new File("tmp.txt").renameTo(new File(SettingsManager.QUESTIONS_FILENAME));
						
						new File("tmp.txt").delete();
						
						// update settings date
						settings.setQuestionFileDate(settings.getQuestionFileLastUpdate());
						settings.saveSettings(".settings.json");
					}
					if (alert.getResult() == ButtonType.NO)
					{
						new File("tmp.txt").delete();
					}
				}
				else
				{
					System.out.println("Non sono state trovate nuove domande.");
				}
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