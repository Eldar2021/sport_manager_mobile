part of 'settings_cubit.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.locale = const Locale('en'),
  });

  final ThemeMode themeMode;
  final Locale locale;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) => SettingsState(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
  );

  @override
  List<Object?> get props => [themeMode, locale];
}
