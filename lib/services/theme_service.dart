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

  // Helper method to get text theme with current font size
  TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(fontSize: _fontSize + 8),
    displayMedium: TextStyle(fontSize: _fontSize + 6),
    displaySmall: TextStyle(fontSize: _fontSize + 4),
    headlineMedium: TextStyle(fontSize: _fontSize + 2),
    headlineSmall: TextStyle(fontSize: _fontSize),
    titleLarge: TextStyle(fontSize: _fontSize),
    bodyLarge: TextStyle(fontSize: _fontSize),
    bodyMedium: TextStyle(fontSize: _fontSize - 2),
    titleMedium: TextStyle(fontSize: _fontSize - 2),
    titleSmall: TextStyle(fontSize: _fontSize - 4),
    labelLarge: TextStyle(fontSize: _fontSize - 2),
    bodySmall: TextStyle(fontSize: _fontSize - 4),
    labelSmall: TextStyle(fontSize: _fontSize - 6),
  );
}