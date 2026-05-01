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
        children: const [
          _AppearanceSection(),
        ],
      ),
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.settingsAppearance,
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        const Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeModeTile(),
              Divider(),
              _LanguageTile(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (a, b) => a.themeMode != b.themeMode,
      builder: (context, state) {
        return _SettingsTile(
          icon: _iconFor(state.themeMode),
          iconColor: context.colors.primary,
          title: context.l10n.settingsThemeMode,
          value: _labelFor(context, state.themeMode),
          onTap: () => ThemeModePickerSheet.show(context),
        );
      },
    );
  }

  IconData _iconFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.system => Icons.brightness_auto_outlined,
  };

  String _labelFor(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.light => context.l10n.settingsThemeLight,
    ThemeMode.dark => context.l10n.settingsThemeDark,
    ThemeMode.system => context.l10n.settingsThemeSystem,
  };
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (a, b) => a.locale != b.locale,
      builder: (context, state) {
        return _SettingsTile(
          icon: Icons.translate_rounded,
          iconColor: context.appColors.success,
          title: context.l10n.settingsLanguage,
          value: AppLocalizationHelper.getName(state.locale.languageCode),
          onTap: () => LanguagePickerSheet.show(context),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: AppOpacity.tint),
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: SizedBox(
          height: AppSpacing.x10,
          width: AppSpacing.x10,
          child: Icon(icon, color: iconColor),
        ),
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: context.appTextStyles.muted.bodySmall,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: AppSpacing.x4,
      ),
    );
  }
}
