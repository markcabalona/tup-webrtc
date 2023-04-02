// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuplive/core/utils/secure_storage.dart';

part 'app_theme_state.dart';

/// App ThemeMode Cubit.
///
/// This cubit handles the app's thememode changes.
///
/// It also saves the thememode to local storage
///
/// NOTE: Do not forget to call initializeTheme(), if not initialized, it will always default `state.isDark = false`.
class AppThemeModeCubit extends Cubit<AppThemeModeState> {
  final FlutterSecureStorage storage;
  AppThemeModeCubit({
    required this.storage,
  }) : super(const AppThemeModeState(
          isDark: false,
        ));

  /// Initialize theme mode.
  ///
  /// Fetches ThemeMode status in the local storage. (checks `StorageKeys.isDarkMode`)
  ///
  /// `StorageKeys.isDarkMode`'s value will be assigned to `state.isDark` if it is not null, otherwise, `state.language` will be null
  Future<void> initializeTheme() async {
    final isDark = await storage.read(key: StorageKeys.isDarkMode);

    emit(state.copyWith(
      isDark: isDark != null
          ? fromJson<bool>(isDark)
          : SchedulerBinding.instance.window.platformBrightness ==
              Brightness.dark,
    ));
  }

  /// Changes the theme mode
  ///
  /// This method also saves the thememode to local storage.(sets `StorageKeys.isDarkMode` to `state.isDark`'s value)
  void changeTheme() async {
    emit(state.copyWith(isDark: !state.isDark));

    await storage.write(
      key: StorageKeys.isDarkMode,
      value: toJson(state.isDark),
    );
  }
}
