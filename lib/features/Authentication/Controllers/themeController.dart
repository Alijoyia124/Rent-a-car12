import 'package:flutter/material.dart';

class ThemeController {
  static final ThemeController _instance = ThemeController._internal();

  factory ThemeController() {
    return _instance;
  }

  ThemeController._internal();

  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    themeMode = (themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
  }
}
