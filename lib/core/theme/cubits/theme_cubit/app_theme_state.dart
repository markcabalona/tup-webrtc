// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_theme_cubit.dart';

/// [isDark] determine if app is in dark mode
class AppThemeModeState extends Equatable {
  final bool isDark;

  const AppThemeModeState({
    required this.isDark,
  });

  AppThemeModeState copyWith({
    bool? isDark,
  }) =>
      AppThemeModeState(
        isDark: isDark ?? this.isDark,
      );

  @override
  List<Object> get props => [isDark];
}
