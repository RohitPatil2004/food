import 'package:flutter/material.dart';

class ThemeService with ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 16.0;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }

  void resetPreferences() {
    _isDarkMode = false;
    _fontSize = 16.0;
    notifyListeners();
  }
}
