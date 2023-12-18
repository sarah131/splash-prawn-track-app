import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDark => themeMode == ThemeMode.dark;

  void toggleTheme(bool ison) {
    themeMode = ison ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class themeShifter {
  static final darktheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xffDADEEC),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
      ),
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.white));

  static final lighttheme = ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(51, 51, 51, 1),
      colorScheme: const ColorScheme.dark(),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.black));
}
