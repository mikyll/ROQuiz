module roquiz {
	requires javafx.controls;
	requires javafx.fxml;
	requires transitive javafx.base;
	requires transitive javafx.graphics;
	requires com.google.gson;
	
	opens gui;
	
	exports application;
	exports gui;
	exports model;
	exports persistence;
}