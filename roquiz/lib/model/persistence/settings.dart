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
  bool themeDark;
  String githubToken;

  // Quiz
  int? writtenGrade;
  bool fullTopics;
  int quizPool;
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
    this.themeDark = false,
    this.githubToken = "",
    this.fullTopics = false,
    this.quizPool = 16,
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
