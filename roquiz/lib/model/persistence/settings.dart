import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart'; // This will be generated

@JsonSerializable()
class Settings with ChangeNotifier {
  // General
  String language;
  bool autoCheckRelease;
  bool autoCheckQuestions;
  bool animations;
  bool? confirmationAlert;
  bool hideCorrectAnswersInEditMode;
  bool themeDark;
  String githubToken;

  // Quiz
  int? writtenGrade;
  bool fullTopics;
  int quizQuestions;
  int quizTime;
  bool shuffleAnswers;
  bool exceedTimeout;

  // Accessibility
  bool leftHandedLayout;

  Settings({
    this.language = "Italiano",
    this.autoCheckRelease = true,
    this.autoCheckQuestions = true,
    this.animations = true,
    this.confirmationAlert = true,
    this.hideCorrectAnswersInEditMode = false,
    this.themeDark = false,
    this.githubToken = "",
    this.fullTopics = false,
    this.quizQuestions = 16,
    this.quizTime = 18,
    this.shuffleAnswers = true,
    this.exceedTimeout = false,
    this.leftHandedLayout = false,
  });

  // Automatically generated methods
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
