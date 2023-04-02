import 'package:flutter/material.dart';

abstract class AppColors {
  static const Map<int, Color> _primaryDark = <int, Color>{
    50: Color.fromRGBO(240, 230, 195, .1),
    100: Color.fromRGBO(240, 230, 195, .2),
    200: Color.fromRGBO(240, 230, 195, .3),
    300: Color.fromRGBO(240, 230, 195, .4),
    400: Color.fromRGBO(240, 230, 195, .5),
    500: Color.fromRGBO(240, 230, 195, .6),
    600: Color.fromRGBO(240, 230, 195, .7),
    700: Color.fromRGBO(240, 230, 195, .8),
    800: Color.fromRGBO(240, 230, 195, .9),
    900: Color.fromRGBO(240, 230, 195, 1),
  };
  static const Map<int, Color> _primary = <int, Color>{
    50: Color.fromRGBO(152, 17, 109, .1),
    100: Color.fromRGBO(152, 17, 109, .2),
    200: Color.fromRGBO(152, 17, 109, .3),
    300: Color.fromRGBO(152, 17, 109, .4),
    400: Color.fromRGBO(152, 17, 109, .5),
    500: Color.fromRGBO(152, 17, 109, .6),
    600: Color.fromRGBO(152, 17, 109, .7),
    700: Color.fromRGBO(152, 17, 109, .8),
    800: Color.fromRGBO(152, 17, 109, .9),
    900: Color.fromRGBO(152, 17, 109, 1),
  };
  static const Map<int, Color> _background = <int, Color>{
    50: Color.fromRGBO(255, 255, 255, .1),
    100: Color.fromRGBO(255, 255, 255, .2),
    200: Color.fromRGBO(255, 255, 255, .3),
    300: Color.fromRGBO(255, 255, 255, .4),
    400: Color.fromRGBO(255, 255, 255, .5),
    500: Color.fromRGBO(255, 255, 255, .6),
    600: Color.fromRGBO(255, 255, 255, .7),
    700: Color.fromRGBO(255, 255, 255, .8),
    800: Color.fromRGBO(255, 255, 255, .9),
    900: Color.fromRGBO(255, 255, 255, 1),
  };

  static const MaterialColor primary = MaterialColor(0xff98116D, _primary);
  static const Color wine = Color(0xff490B3A);
  static const Color brightPlum = Color(0xffAA2986);

  static const Color cream = Color(0xfff0e6c3);
  static const Color bone = Color(0xffC9BD99);
  static const Color darkBone = Color(0xffA89D80);

  static const MaterialColor background =
      MaterialColor(0xFFFFFFFF, _background);
  static const MaterialColor primaryDark =
      MaterialColor(0xfff0e6c3, _primaryDark);

  static const primaryGradient = LinearGradient(colors: [
    wine,
    primary,
  ]);

  static const primaryGradientDark = LinearGradient(colors: [
    darkBone,
    bone,
    primaryDark,
  ]);

  static const greyGradient = LinearGradient(colors: [
    Color.fromARGB(255, 130, 130, 130),
    Color.fromARGB(255, 182, 182, 182),
  ]);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff98116D),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD9E4),
    onPrimaryContainer: Color(0xFF3E0020),
    secondary: Color(0xFF735660),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFD9E4),
    onSecondaryContainer: Color(0xFF2A151D),
    tertiary: Color(0xFF7D5636),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDCC3),
    onTertiaryContainer: Color(0xFF2F1500),
    error: Color(0xffDE2910),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A1C),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A1C),
    surfaceVariant: Color(0xFFF2DDE2),
    onSurfaceVariant: Color(0xFF514347),
    outline: Color(0xFF837377),
    onInverseSurface: Color(0xFFFAEEF0),
    inverseSurface: Color(0xFF352F30),
    inversePrimary: Color(0xffefe6c3),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xff98116D),
    outlineVariant: Color(0xFFD5C2C6),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffefe6c3),
    onPrimary: Color(0xFF640037),
    primaryContainer: Color(0xFF890F50),
    onPrimaryContainer: Color(0xFFFFD9E4),
    secondary: Color(0xFFE2BDC8),
    onSecondary: Color(0xFF422932),
    secondaryContainer: Color(0xFF5A3F48),
    onSecondaryContainer: Color(0xFFFFD9E4),
    tertiary: Color(0xFFF0BC95),
    onTertiary: Color(0xFF48290D),
    tertiaryContainer: Color(0xFF623F21),
    onTertiaryContainer: Color(0xFFFFDCC3),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A1C),
    onBackground: Color(0xFFEBE0E1),
    surface: Color(0xFF201A1C),
    onSurface: Color(0xFFEBE0E1),
    surfaceVariant: Color(0xFF514347),
    onSurfaceVariant: Color(0xFFD5C2C6),
    outline: Color(0xFF9D8C91),
    onInverseSurface: Color(0xFF201A1C),
    inverseSurface: Color(0xFFEBE0E1),
    inversePrimary: Color(0xff98116D),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xffefe6c3),
    outlineVariant: Color(0xFF514347),
    scrim: Color(0xFF000000),
  );
}
