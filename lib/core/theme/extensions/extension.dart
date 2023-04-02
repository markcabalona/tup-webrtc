import 'package:flutter/material.dart';

extension CustomStyles on TextTheme {
  TextStyle get subtitle3 {
    return const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(152, 17, 109, 1),
    );
  }

  TextStyle get darkSubtitle3 {
    return const TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle get bodyText3 {
    return const TextStyle(
      color: Color.fromRGBO(152, 17, 109, 1),
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  TextStyle get darkBodyText3 {
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  TextStyle get subtitle4 {
    return const TextStyle(
      color: Color.fromRGBO(152, 17, 109, 1),
    );
  }

  TextStyle get darkSubtitle4 {
    return const TextStyle(
      color: Colors.white,
    );
  }
}
