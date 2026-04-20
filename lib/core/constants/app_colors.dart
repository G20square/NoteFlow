import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A42CC);
  static const Color secondary = Color(0xFFFF6584);
  static const Color accent = Color(0xFF43CFBE);

  // Background
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF252525);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF666680);
  static const Color textPrimaryDark = Color(0xFFF0F0FF);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  // Note card palette (10 colors)
  static const List<Color> noteColorsLight = [
    Color(0xFFFFFFFF), // default white
    Color(0xFFFFF9C4), // yellow
    Color(0xFFFFCDD2), // red
    Color(0xFFC8E6C9), // green
    Color(0xFFBBDEFB), // blue
    Color(0xFFE1BEE7), // purple
    Color(0xFFFFCCBC), // orange
    Color(0xFFB2EBF2), // cyan
    Color(0xFFF8BBD9), // pink
    Color(0xFFDCEDC8), // lime
  ];

  static const List<Color> noteColorsDark = [
    Color(0xFF2C2C2C), // default dark
    Color(0xFF5C4A00), // yellow
    Color(0xFF5C1414), // red
    Color(0xFF1A3D1A), // green
    Color(0xFF0D2B4A), // blue
    Color(0xFF3D1A5C), // purple
    Color(0xFF5C2A00), // orange
    Color(0xFF003D47), // cyan
    Color(0xFF4A0D2E), // pink
    Color(0xFF2B3D0D), // lime
  ];

  // Labels
  static const Color workLabel = Color(0xFF2196F3);
  static const Color personalLabel = Color(0xFF4CAF50);
  static const Color studyLabel = Color(0xFFFF9800);
  static const Color ideasLabel = Color(0xFF9C27B0);
  static const Color healthLabel = Color(0xFFF44336);
  static const Color financeLabel = Color(0xFF009688);
}
