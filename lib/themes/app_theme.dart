import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode;
  String _fontFamily;
  Color? _customPrimaryColor;

  ThemeProvider({
    required bool isDarkMode,
    required String fontFamily,
    Color? customPrimaryColor,
  })  : _isDarkMode = isDarkMode,
        _fontFamily = fontFamily,
        _customPrimaryColor = customPrimaryColor;

  bool get isDarkMode => _isDarkMode;
  String get fontFamily => _fontFamily;
  Color? get customPrimaryColor => _customPrimaryColor;

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: _customPrimaryColor ?? Colors.blue,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _customPrimaryColor ?? Colors.blue,
        ),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primarySwatch: Colors.indigo,
      primaryColor: _customPrimaryColor ?? Colors.indigo,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _customPrimaryColor ?? Colors.indigo,
        ),
      ),
    );
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setCustomPrimaryColor(Color color) async {
    _customPrimaryColor = color;
    notifyListeners();
  }

  Future<void> setFontFamily(String fontFamily) async {
    _fontFamily = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', fontFamily);
    notifyListeners();
  }
}

// Constantes de colores para usar en la app
class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color primaryDarkColor = Colors.indigo;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color backgroundDarkColor = Color(0xFF121212);
  static const Color textColor = Colors.black87;
  static const Color textDarkColor = Colors.white;
}