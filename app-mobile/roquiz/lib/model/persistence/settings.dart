import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Settings {
  // TODO
  static const SHOW_APP_LOGO = false;
  static const APP_TITLE = "ROQuiz";
  static const VERSION_NUMBER = "v1.0.0";

  final Map<String, _Setting> _defaults = {
    "check_update_app": _Setting.fromDefault(
        true, "Automatically check for new releases of the application"),
    "check_update_questions":
        _Setting.fromDefault(true, "Automatically check for new questions"),
    "whole_topics": _Setting.fromDefault(true,
        "Select to have full topics in quiz instead of a pool of questions"),
    "quiz_pool": _Setting.fromDefault(
        16, "Number of questions that will be picked for the quiz"),
    "timer": _Setting.fromDefault(18, "Time available to complete the quiz"),
    "shuffle_answers": _Setting.fromDefault(
        true, "Shuffle answers so that you don't memorize them by their order"),
    "confirm_alerts":
        _Setting.fromDefault(false, "Always show a confirmation dialog"),
    "open_url_in_app": _Setting.fromDefault(
        false, "Choose wether to open URLs in device browser or in-app"),
    "dark_theme": _Setting.fromDefault(false, "Dark theme"),
  };
  late Map<String, _Setting> _entries = {};

  // Settings(this._entries);

  Settings._fromJSON(String json) {
    _entries = jsonDecode(json);
  }

  String _toJSON() {
    return jsonEncode(_entries);
  }

  dynamic getValue(String key) {
    if (!_entries.containsKey(key)) {
      // TODO
      throw Exception("TODO");
    }
    return _entries[key]!.value;
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

    prefs.setString("settings", _toJSON());
  }

  static Future<Settings> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    Settings settings = Settings._fromJSON(prefs.getString("settings")!);

    return settings;
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
          "[\"$key\"]: ${_entries[key]!.value}, ${_entries[key]!.defaultValue}\n\t\"${_entries[key]!.description}\"";
    }
    return res;
  }
}

class _Setting {
  late dynamic value;
  late dynamic defaultValue;
  late String description;

  _Setting(dynamic sValue, dynamic sDefaultValue, String sDescription) {
    if (sValue.runtimeType != sDefaultValue.runtimeType) {
      // TODO: custom Exception
      throw Exception("value and defaultValue must have the same type");
    }
    value = sValue;
    defaultValue = sDefaultValue;
    description = sDescription;
  }
  _Setting.fromDefault(dynamic sDefaultValue, String sDescription) {
    value = sDefaultValue;
    defaultValue = sDefaultValue;
    description = sDescription;
  }
}

void main() async {
  Settings settings = await Settings.loadFromSharedPreferences();

  print(settings.toString());
}
