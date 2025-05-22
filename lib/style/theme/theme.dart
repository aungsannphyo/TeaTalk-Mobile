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
    onPrimary: Colors.white, // Fix: onPrimary should be contrast to primary
    secondary: AppColors.accent,
    onSecondary:
        Colors.white, // Fix: onSecondary should be contrast to secondary
    error: AppColors.danger,
    onError: Colors.white, // Fix: onError should be contrast to error
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
    foregroundColor:
        Colors.white, // Fix: foregroundColor should be contrast to background
    elevation: 1,
  ),

  // Elevated Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.complementary,
      foregroundColor: AppColors.textDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),

  // Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor:
        Colors.white, // Fix: foregroundColor should be contrast to background
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    labelStyle: const TextStyle(color: AppColors.textDark),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.complementary),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.accent, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.accent,
    contentTextStyle: TextStyle(
        color: Colors
            .white), // Fix: contentTextStyle should be contrast to background
    behavior: SnackBarBehavior.floating,
  ),

  // Icons
  iconTheme: const IconThemeData(color: AppColors.primary),
);
