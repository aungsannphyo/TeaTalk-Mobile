import 'package:flutter/material.dart';
import './app_color.dart';

final ThemeData teaTalkTheme = ThemeData(
  useMaterial3: true,

  // Base colors
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.white, // White background as requested
  hintColor: AppColors.complementary,

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white, // Text/icons on primary colored elements
    secondary: AppColors.accent,
    onSecondary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    surface: Colors.white,
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

  // AppBar - white background, tea brown text/icons
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.background,
    elevation: 1,
    iconTheme: IconThemeData(color: AppColors.background),
    titleTextStyle: TextStyle(
      color: AppColors.background,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
    ),
  ),

  // Elevated Buttons - tea brown background, white text
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
  ),

  // Floating Action Button - accent color background, white icons
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: Colors.white,
  ),

  // Input Fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
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

  // SnackBar - accent color background, white text
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.accent,
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
  ),

  // Icons default color in the app (e.g., buttons, navigation)
  iconTheme: const IconThemeData(color: AppColors.primary),
);
