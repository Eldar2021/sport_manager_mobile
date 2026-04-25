import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

const List<({String code})> _kLangs = [
  (code: 'ru'),
  (code: 'ky'),
  (code: 'en'),
];

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.watch<SettingsCubit>().state.locale.languageCode;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.language, color: AppColors.ink500),
        const SizedBox(width: AppSpacing.x4),
        for (int i = 0; i < _kLangs.length; i++) ...[
          if (i > 0) ...[
            const SizedBox(width: AppSpacing.x2),
            Text('•', style: textTheme.bodySmall?.copyWith(color: AppColors.ink500)),
            const SizedBox(width: AppSpacing.x2),
          ],
          GestureDetector(
            onTap: () => context.read<SettingsCubit>().setLocale(Locale(_kLangs[i].code)),
            child: Text(
              _kLangs[i].code.toUpperCase(),
              style: textTheme.bodySmall?.copyWith(
                color: _kLangs[i].code == code ? AppColors.brandAmber : AppColors.ink500,
                fontWeight: _kLangs[i].code == code ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
