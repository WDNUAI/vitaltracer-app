import 'package:flutter/material.dart';
///Method for theme notifier extrpolated from  https://dev.to/kiani0x01/the-most-simple-and-easy-way-to-implement-light-theme-and-dark-theme-multiple-themes-in-your-flutter-app-248i
class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);
