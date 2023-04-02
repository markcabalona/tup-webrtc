import 'dart:convert';

/// Contains all the FlutterSecureStorage Keys used for this app
abstract class StorageKeys {
  static const isDarkMode = 'IS_DARK_MODE';
  static const languageCode = 'LANGUAGE_CODE';
}

/// Converts [value] to a json string.
String toJson<T>(T value) => json.encode(value);

/// Converts json string to a type [T].
T fromJson<T>(String jsonString) => json.decode(jsonString);
