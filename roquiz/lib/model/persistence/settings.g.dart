// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  language: json['language'] as String? ?? "Italiano",
  autoCheckRelease: json['autoCheckRelease'] as bool? ?? true,
  autoCheckQuestions: json['autoCheckQuestions'] as bool? ?? true,
  animations: json['animations'] as bool? ?? true,
  confirmationAlert: json['confirmationAlert'] as bool? ?? true,
  themeDark: json['themeDark'] as bool? ?? false,
  githubToken: json['githubToken'] as String? ?? "",
  fullTopics: json['fullTopics'] as bool? ?? false,
  quizPool: (json['quizPool'] as num?)?.toInt() ?? 16,
  quizTime: (json['quizTime'] as num?)?.toInt() ?? 18,
  shuffleAnswers: json['shuffleAnswers'] as bool? ?? true,
  exceedTimeout: json['exceedTimeout'] as bool? ?? false,
  leftHandedLayout: json['leftHandedLayout'] as bool? ?? false,
)..writtenGrade = (json['writtenGrade'] as num?)?.toInt();

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'language': instance.language,
  'autoCheckRelease': instance.autoCheckRelease,
  'autoCheckQuestions': instance.autoCheckQuestions,
  'animations': instance.animations,
  'confirmationAlert': instance.confirmationAlert,
  'themeDark': instance.themeDark,
  'githubToken': instance.githubToken,
  'writtenGrade': instance.writtenGrade,
  'fullTopics': instance.fullTopics,
  'quizPool': instance.quizPool,
  'quizTime': instance.quizTime,
  'shuffleAnswers': instance.shuffleAnswers,
  'exceedTimeout': instance.exceedTimeout,
  'leftHandedLayout': instance.leftHandedLayout,
};
