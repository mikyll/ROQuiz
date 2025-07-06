import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/style/theme_provider.dart';
import 'package:roquiz/model/style/themes.dart';
import 'package:roquiz/view/view_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isDarkTheme = false;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return runApp(
    ChangeNotifierProvider<ThemeProvider>(
      child: ROQuizApp(packageInfo: packageInfo),
      create: (BuildContext context) {
        return ThemeProvider(isDarkTheme);
      },
    ),
  );
}

class ROQuizApp extends StatelessWidget {
  const ROQuizApp({super.key, required this.packageInfo});

  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          title: packageInfo.appName,
          themeMode: value.themeMode,
          theme: Themes.themeLight,
          darkTheme: Themes.themeDark,
          home: ViewMenu(packageInfo: packageInfo),
        );
      },
    );
  }
}
