import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart'; // This will be generated

/// How aggressively the app asks the user to confirm actions. Ordered by
/// increasing number of prompts, so `.index` can be compared against the
/// minimum level a given confirmation site requires (see `maybeConfirm`).
///  - [none]: never prompt.
///  - [soft]: prompt only before irreversible data loss (delete/clear/reset).
///  - [full]: additionally prompt before losing in-progress work (leaving a
///    quiz, terminating with unanswered questions).
enum ConfirmationLevel { none, soft, full }

@JsonSerializable()
class Settings with ChangeNotifier {
  // NB: after editing this class, run `dart run build_runner build`

  // General
  String language;
  bool autoCheckRelease;
  bool autoCheckQuestions;
  bool animations;
  ConfirmationLevel confirmationLevel;
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
    this.confirmationLevel = ConfirmationLevel.soft,
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

  /// Resets every setting to its constructor default, mutating this instance in
  /// place so the shared [Provider] reference (and its listeners) keep pointing
  /// at the same object. Call [SettingsManager.save] afterwards to persist and
  /// notify listeners.
  void restoreDefaults() {
    final Settings d = Settings();
    language = d.language;
    autoCheckRelease = d.autoCheckRelease;
    autoCheckQuestions = d.autoCheckQuestions;
    animations = d.animations;
    confirmationLevel = d.confirmationLevel;
    hideCorrectAnswersInEditMode = d.hideCorrectAnswersInEditMode;
    themeDark = d.themeDark;
    githubToken = d.githubToken;
    writtenGrade = d.writtenGrade;
    fullTopics = d.fullTopics;
    quizQuestions = d.quizQuestions;
    quizTime = d.quizTime;
    shuffleAnswers = d.shuffleAnswers;
    exceedTimeout = d.exceedTimeout;
    leftHandedLayout = d.leftHandedLayout;
  }

  // Automatically generated methods
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
