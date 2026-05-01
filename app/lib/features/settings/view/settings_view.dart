import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.x4),
        children: [
          Text(
            context.l10n.settingsAppearance,
            style: context.appTextStyles.disabled.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x2),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<SettingsCubit, SettingsState>(
                  buildWhen: (a, b) => a.themeMode != b.themeMode,
                  builder: (context, state) {
                    return SettingsTile(
                      icon: _iconFor(state.themeMode),
                      iconColor: context.colors.primary,
                      title: context.l10n.settingsThemeMode,
                      value: _labelFor(context, state.themeMode),
                      onTap: () => ThemeModePickerSheet.show(context),
                    );
                  },
                ),
                const Divider(),
                BlocBuilder<SettingsCubit, SettingsState>(
                  buildWhen: (a, b) => a.locale != b.locale,
                  builder: (context, state) {
                    return SettingsTile(
                      icon: Icons.translate_rounded,
                      iconColor: context.appColors.success,
                      title: context.l10n.settingsLanguage,
                      value: AppLocalizationHelper.getName(state.locale.languageCode),
                      onTap: () => LanguagePickerSheet.show(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      ThemeMode.system => Icons.brightness_auto_outlined,
    };
  }

  String _labelFor(BuildContext context, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => context.l10n.settingsThemeLight,
      ThemeMode.dark => context.l10n.settingsThemeDark,
      ThemeMode.system => context.l10n.settingsThemeSystem,
    };
  }
}
