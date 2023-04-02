import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuplive/core/theme/colors.dart';

/// `AppTheme.lightTheme` returns ThemeData for light mode
///
/// `AppTheme.darkTheme` returns ThemeData for dark mode
abstract class AppTheme {
  static ThemeData _baseTheme({required ColorScheme colorScheme}) => ThemeData(
      fontFamily: GoogleFonts.montserrat().fontFamily,
      primaryColor: AppColors.primary,
      useMaterial3: true,
      colorScheme: colorScheme,
      dividerColor: Colors.transparent,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        alignLabelWithHint: true,
      ));
  static final ThemeData lightTheme = _baseTheme(
    colorScheme: AppColors.lightColorScheme,
  );

  static final ThemeData darkTheme = _baseTheme(
    colorScheme: AppColors.darkColorScheme,
  );
}
