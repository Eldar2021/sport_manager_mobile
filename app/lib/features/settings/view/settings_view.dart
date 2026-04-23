import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.homeWelcomeBack,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SettingsSectionTitle(l10n.settingsAppearance),
              _ThemeModeSelector(current: state.themeMode),
              SettingsSectionTitle(l10n.settingsLanguage),
              _LanguageSelector(current: state.locale),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.current});

  final ThemeMode current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    return Row(
      children: [
        ThemeModeCard(
          icon: Icons.light_mode_rounded,
          label: l10n.settingsThemeLight,
          isSelected: current == ThemeMode.light,
          onTap: () => cubit.setThemeMode(ThemeMode.light),
        ),
        ThemeModeCard(
          icon: Icons.dark_mode_rounded,
          label: l10n.settingsThemeDark,
          isSelected: current == ThemeMode.dark,
          onTap: () => cubit.setThemeMode(ThemeMode.dark),
        ),
        ThemeModeCard(
          icon: Icons.phone_iphone_rounded,
          label: l10n.settingsThemeSystem,
          isSelected: current == ThemeMode.system,
          onTap: () => cubit.setThemeMode(ThemeMode.system),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.current});

  final Locale current;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return Column(
      children: [
        for (final locale in AppLocalizationHelper.locales) ...[
          LanguageTile(
            name: AppLocalizationHelper.getName(locale.languageCode),
            isSelected: current.languageCode == locale.languageCode,
            onTap: () => cubit.setLocale(locale),
          ),
        ],
      ],
    );
  }
}
