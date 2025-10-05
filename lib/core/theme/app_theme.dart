import 'package:flutter/material.dart';

class AppTheme {
  // رنگ‌های اصلی
  static const Color _primaryBlue = Color(0xFF50A1C6); // آبی متوسط
  static const Color _accentBlue = Color(0xFF0098FF); // آبی روشن
  static const Color _backgroundLight = Color(0xFFF5F7FA);
  static const Color _backgroundDark = Color(0xFF1E1E1E);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF2C2F36);
  static const Color _appBarLight = Color.fromARGB(255, 252, 253, 255);
  static const Color _appBarDark = Color(0xFF1E1E1E);

  // تم لایت
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Vazir",
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _backgroundLight,
    cardColor: _cardLight,
    dividerColor: Colors.grey.shade300,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.light,
      primary: _primaryBlue,
      secondary: _accentBlue,
      background: _backgroundLight,
      error: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _appBarLight,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _accentBlue,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _appBarLight,
      selectedItemColor: _primaryBlue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Vazir',
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Vazir',
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  // تم دارک
  static final ThemeData darkTheme = ThemeData(
    fontFamily: "Vazir",
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _backgroundDark,
    cardColor: _cardDark,
    dividerColor: Colors.grey.shade800,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.dark,
      primary: _primaryBlue,
      secondary: _accentBlue,
      background: _backgroundDark,
      error: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _appBarDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _accentBlue,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _backgroundDark,
      selectedItemColor: _accentBlue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Vazir',
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Vazir',
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
