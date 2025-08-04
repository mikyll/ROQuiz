import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static bool isDefault(Settings settings) {
    Settings defaultSettings = Settings();

    return defaultSettings == settings;
  }

  static Future<Settings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('settings');

    Settings settings;
    if (json != null) {
      settings = Settings.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } else {
      settings = Settings();
    }

    return Future.value(settings);
  }

  static Future<void> save(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(settings.toJson()));
    settings.notifyListeners();

    return Future.value();
  }
}
