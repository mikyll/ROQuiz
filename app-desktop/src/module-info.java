module roquiz {
	requires javafx.controls;
	requires javafx.fxml;
	requires transitive javafx.base;
	requires transitive javafx.graphics;
	requires com.google.gson;
	
	opens gui;
	opens model to com.google.gson;
	
	exports application;
	exports gui;
	exports model;
	exports persistence;
}