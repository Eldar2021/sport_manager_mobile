import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: AppLocalizationHelper.locales.map((locale) {
            return ChoiceChip(
              side: BorderSide.none,
              backgroundColor: AppColors.transparent,
              showCheckmark: false,
              label: Text(
                AppLocalizationHelper.getShortName(locale.languageCode),
              ),
              selected: locale == state.locale,
              onSelected: (value) {
                if (value) {
                  context.read<SettingsCubit>().setLocale(locale);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
