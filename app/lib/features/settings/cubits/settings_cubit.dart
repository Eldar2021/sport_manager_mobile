import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_client/storage_client.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._storage) : super(const SettingsState());

  final StorageInterfaceSyncRead _storage;

  static const _themeKey = 'settings_theme_mode';
  static const _localeKey = 'settings_locale';

  void init() {
    final themeIndex = _storage.readInt(_themeKey);
    final localeCode = _storage.readString(_localeKey);

    emit(
      SettingsState(
        themeMode: themeIndex != null ? ThemeMode.values[themeIndex] : ThemeMode.light,
        locale: Locale(localeCode ?? 'en'),
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _storage.writeInt(
      key: _themeKey,
      value: mode.index,
    );
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _storage.writeString(
      key: _localeKey,
      value: locale.languageCode,
    );
  }
}
