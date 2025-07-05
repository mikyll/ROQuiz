import 'package:roquiz/model/persistence/setting_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Settings {
  // TODO
  static const SHOW_APP_LOGO = false;
  static const APP_TITLE = "ROQuiz";
  static const VERSION_TAG = "v1.0.0";

  final Map<String, _Setting> _defaults = {
    "check_update_app": _Setting.fromDefault(
      type: SettingType.toggleCheckboxAndButton,
      defaultValue: true,
      label: "Check for app releases",
      description: "Automatically check for new releases of the application",
    ),
    "check_update_questions": _Setting.fromDefault(
      type: SettingType.toggleCheckboxAndButton,
      defaultValue: true,
      label: "Check for new questions",
      description: "Automatically check for new questions",
    ),
    "whole_topics": _Setting.fromDefault(
      type: SettingType.toggleCheckbox,
      defaultValue: true,
      label: "Full topics",
      description:
          "Select to have full topics in quiz instead of a pool of questions",
    ),
    "quiz_pool": _Setting.fromDefault(
      type: SettingType.spinner,
      defaultValue: 16,
      label: "Quiz pool",
      description: "Number of questions that will be picked for the quiz",
    ),
    "timer": _Setting.fromDefault(
      type: SettingType.spinner,
      defaultValue: 18,
      label: "timer",
      description: "Time available to complete the quiz (in minutes)",
    ),
    "shuffle_answers": _Setting.fromDefault(
      type: SettingType.toggleCheckbox,
      defaultValue: true,
      label: "Shuffle answers",
      description:
          "Shuffle answers so that you don't memorize them by their order",
    ),
    "confirm_alerts": _Setting.fromDefault(
      type: SettingType.toggleCheckbox,
      defaultValue: false,
      label: "Confirm alert",
      description: "Always show a confirmation dialog",
    ),
    "open_url_in_app": _Setting.fromDefault(
      type: SettingType.toggleCheckbox,
      defaultValue: false,
      label: "Open URL in-app",
      description:
          "Choose wether to open URLs in-app or using device's default browser",
    ),
    "use_system_theme": _Setting.fromDefault(
      type: SettingType.toggleSwitch,
      defaultValue: true,
      label: "Use system's theme",
      description: "Use system theme",
    ),
    "dark_theme": _Setting.fromDefault(
      type: SettingType.toggleSwitch,
      defaultValue: false,
      label: "Dark theme",
      description: "Dark theme",
    ),
  };
  late Map<String, _Setting> _entries = {};

  Settings(this._entries);

  Settings.fromDefault() {
    _entries = _defaults;
  }

  Settings._fromJSON(String json) {
    _entries = jsonDecode(json);
  }

  List<String> getKeys() {
    return _entries.keys.toList();
  }

  SettingType getType(String key) {
    if (!_entries.containsKey(key)) {
      // TODO
      throw Exception("TODO");
    }
    return _entries[key]!.type;
  }

  dynamic getValue(String key) {
    if (!_entries.containsKey(key)) {
      // TODO
      throw Exception("TODO");
    }
    return _entries[key]!.value;
  }

  String getLabel(String key) {
    if (!_entries.containsKey(key)) {
      // TODO
      throw Exception("TODO");
    }
    return _entries[key]!.label;
  }

  String getDescription(String key) {
    if (!_entries.containsKey(key)) {
      // TODO
      throw Exception("TODO");
    }
    return _entries[key]!.description;
  }

  void saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // TODO: test
    print(_toJSON());
    prefs.setString("settings", _toJSON());
  }

  static Future<Settings> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    Settings result;

    String? jsonSettings = prefs.getString("settings");
    if (jsonSettings != null) {
      result = Settings._fromJSON(jsonSettings);
    } else {
      result = Settings.fromDefault();
    }

    return result;
  }

  void _reset() async {
    final prefs = await SharedPreferences.getInstance();

    _entries = _defaults;

    prefs.setString("settings", _toJSON());
  }

  @override
  String toString() {
    String res = "";
    for (String key in _entries.keys) {
      res +=
          "[\"$key\"]: ${_entries[key]!.type}, ${_entries[key]!.value}, ${_entries[key]!.defaultValue}\n${_entries[key]!.label}\n\t\"${_entries[key]!.description}\"";
    }
    return res;
  }

  String _toJSON() {
    return jsonEncode(_entries);
  }
}

class _Setting {
  SettingType type;
  dynamic value;
  dynamic defaultValue;
  String label;
  String description;

  _Setting({
    required this.type,
    required this.value,
    required this.defaultValue,
    required this.label,
    required this.description,
  }) {
    if (value.runtimeType != defaultValue.runtimeType) {
      // TODO: custom Exception
      throw Exception("value and defaultValue must have the same type");
    }
  }
  _Setting.fromDefault(
      {required this.type,
      required this.defaultValue,
      required this.label,
      required this.description}) {
    value = defaultValue;
  }
}

void main() async {
  Settings settings = await Settings.loadFromSharedPreferences();

  print(settings.toString());
}
