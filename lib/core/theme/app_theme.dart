import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: const Color(0xFF6C63FF),
    scaffoldBackgroundColor: const Color(0xFFF6F7FB),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF6C63FF),
      centerTitle: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}