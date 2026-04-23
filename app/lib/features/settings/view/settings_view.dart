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
              _LanguageSelector(current: state.locale),
            ],
          );
        },
      ),
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
