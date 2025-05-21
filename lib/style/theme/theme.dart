import 'package:flutter/material.dart';
import './app_color.dart';

final ThemeData teaTalkTheme = ThemeData(
  useMaterial3: true,

  // Base colors
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  hintColor: AppColors.complementary,

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.background,
    secondary: AppColors.accent,
    onSecondary: AppColors.background,
    error: AppColors.danger,
    onError: AppColors.background,
    surface: AppColors.background,
    onSurface: AppColors.textDark,
  ),

  // Text styles
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ).apply(
    bodyColor: AppColors.textDark,
    displayColor: AppColors.textDark,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.background,
    elevation: 1,
  ),

  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.complementary,
      foregroundColor: AppColors.textDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),

  // Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.background,
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    labelStyle: const TextStyle(color: AppColors.textDark),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.complementary),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.accent, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.accent,
    contentTextStyle: TextStyle(color: AppColors.background),
    behavior: SnackBarBehavior.floating,
  ),

  // Icons
  iconTheme: const IconThemeData(color: AppColors.primary),
);
