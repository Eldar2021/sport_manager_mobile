import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => const LanguagePickerSheet(),
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
            context.l10n.settingsLanguagePickerTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (a, b) => a.locale != b.locale,
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final locale in AppLocalizationHelper.locales)
                    _LanguageOption(
                      locale: locale,
                      isSelected: state.locale.languageCode == locale.languageCode,
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.isSelected,
  });

  final Locale locale;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      selected: isSelected,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: (isSelected ? accent : context.colors.onSurfaceVariant).withValues(
            alpha: AppOpacity.tint,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.x2),
        ),
        child: SizedBox(
          width: AppSpacing.x10,
          height: AppSpacing.x10,
          child: Center(
            child: Text(
              AppLocalizationHelper.getShortName(locale.languageCode),
              style: context.textTheme.labelMedium?.copyWith(
                color: isSelected ? accent : context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        AppLocalizationHelper.getName(locale.languageCode),
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
        context.read<SettingsCubit>().setLocale(locale);
        Navigator.of(context).pop();
      },
    );
  }
}
