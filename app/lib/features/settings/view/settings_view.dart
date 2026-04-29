import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.homeWelcomeBack,
          style: context.textTheme.titleMedium,
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: AppLocalizationHelper.locales
                .map(
                  (locale) => LanguageTile(
                    name: AppLocalizationHelper.getName(locale.languageCode),
                    isSelected: state.locale.languageCode == locale.languageCode,
                    onTap: () => context.read<SettingsCubit>().setLocale(locale),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
