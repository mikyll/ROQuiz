package application;

import java.io.File;

import gui.ControllerMenu;
import model.SettingsSingleton;
import persistence.QuestionRepository;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.layout.AnchorPane;

public class Main extends Application {
	private SettingsSingleton settings;
	
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
		this.settings = SettingsSingleton.getInstance();
		this.settings.loadSettings(".settings.json");
		//initSettings();
		
		try {
			FXMLLoader loader = new FXMLLoader(Main.class.getResource("/gui/ViewMenu.fxml"));
			AnchorPane menu = (AnchorPane) loader.load();
			ControllerMenu controller = loader.getController();
			controller.setHostServices(getHostServices());
			Scene scene = new Scene(menu);
			scene.getStylesheets().add(getClass().getResource("theme_" + (this.settings.isDarkTheme() ? "dark" : "light") + ".css").toExternalForm());
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
	
	/*private void initSettings()
	{
		this.settings.loadSettings(".settings.json");
		
		// download "Domande.txt" from the GitHub repository
		if(this.settings.isCheckQuestionsUpdate())
		{
			System.out.println("Controllo domande aggiornate...");
			boolean res = QuestionRepository.downloadFile("https://raw.githubusercontent.com/mikyll/ROQuiz/main/Domande.txt", "tmp.txt");
			
			if(new File(QUESTIONS_FILENAME).exists() && res)
			{
				// a new file has been found.
				if(QuestionRepository.compareFilesLength("Domande.txt", "tmp.txt") > 0)
				{
					System.out.println("È stata trovata una versione più recente del file contenente le domande.");
					Alert alert = new Alert(AlertType.CONFIRMATION, "", ButtonType.YES, ButtonType.NO);
					alert.setTitle("Finestra di dialogo");
					alert.setHeaderText("È stata trovata una versione più recente del file contenente le domande. Scaricarla?");
					alert.setContentText("Questa azione sovrascriverà il file " + QUESTIONS_FILENAME + " attualmente presente.");
					alert.showAndWait();
					if (alert.getResult() == ButtonType.YES)
					{
						// update Domande.txt with DomandeNew.txt
						new File(QUESTIONS_FILENAME).delete();
						
						new File("tmp.txt").renameTo(new File(QUESTIONS_FILENAME));
					}
					if (alert.getResult() == ButtonType.NO)
					{
						new File("tmp.txt").delete();
					}
				}
				else {
					System.out.println("Non sono state trovate nuove domande.\n");
					new File("tmp.txt").delete();
				}
			}
			else {
				new File("DomandeNuove.txt").delete();
			}
		}
	}*/
}