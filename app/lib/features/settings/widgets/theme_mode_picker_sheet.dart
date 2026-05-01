import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ThemeModePickerSheet extends StatelessWidget {
  const ThemeModePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => const ThemeModePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x4,
        0,
        AppSpacing.x4,
        AppSpacing.x4 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.settingsThemePickerTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (a, b) => a.themeMode != b.themeMode,
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final mode in ThemeMode.values)
                    _ThemeModeOption(
                      mode: mode,
                      isSelected: state.themeMode == mode,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeModeOption extends StatelessWidget {
  const _ThemeModeOption({
    required this.mode,
    required this.isSelected,
  });

  final ThemeMode mode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      selected: isSelected,
      leading: Icon(
        _iconFor(mode),
        color: isSelected ? accent : context.colors.onSurfaceVariant,
      ),
      title: Text(
        _labelFor(context, mode),
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: accent,
            )
          : null,
      onTap: () {
        context.read<SettingsCubit>().setThemeMode(mode);
        Navigator.of(context).pop();
      },
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
