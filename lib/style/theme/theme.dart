import 'package:flutter/material.dart';
import "./color.dart";

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  splashFactory: NoSplash.splashFactory,
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.complementary,
    error: AppColors.danger,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textDark),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
  ),
);
