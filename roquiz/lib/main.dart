import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/persistence/settings_manager.dart';
import 'package:roquiz/model/style/themes.dart';
import 'package:roquiz/view/view_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final Settings settings = await SettingsManager.load();

  return runApp(
    ChangeNotifierProvider<Settings>(
      child: ROQuizApp(packageInfo: packageInfo, settings: settings),
      create: (BuildContext context) {
        return settings;
      },
    ),
  );
}

class ROQuizApp extends StatelessWidget {
  final PackageInfo packageInfo;
  final Settings settings;

  const ROQuizApp({
    super.key,
    required this.packageInfo,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, value, child) {
        return MaterialApp(
          title: packageInfo.appName,
          themeMode: settings.themeDark ? ThemeMode.dark : ThemeMode.light,
          theme: Themes.themeLight,
          darkTheme: Themes.themeDark,
          home: ViewMenu(packageInfo: packageInfo),
        );
      },
    );
  }
}
