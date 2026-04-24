import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/settings/settings.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

typedef _LangEntry = ({String code, String label, String flag});

const List<_LangEntry> _kLangs = [
  (code: 'ru', label: 'Русский', flag: '🇷🇺'),
  (code: 'ky', label: 'Кыргызча', flag: '🇰🇬'),
  (code: 'en', label: 'English', flag: '🇬🇧'),
];

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  void _open(BuildContext context, String currentCode) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => _LanguageSheet(
        currentCode: currentCode,
        onSelect: (code) {
          context.read<SettingsCubit>().setLocale(Locale(code));
          Navigator.pop(sheet);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = context.watch<SettingsCubit>().state.locale.languageCode;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _open(context, code),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language_rounded, size: 18, color: AppColors.ink500),
          const SizedBox(width: AppSpacing.x2),
          RichText(
            text: TextSpan(
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.ink500,
                fontWeight: FontWeight.w500,
              ),
              children: [
                for (int i = 0; i < _kLangs.length; i++) ...[
                  TextSpan(
                    text: _kLangs[i].code.toUpperCase(),
                    style: _kLangs[i].code == code
                        ? textTheme.bodySmall?.copyWith(
                            color: AppColors.brandAmber,
                            fontWeight: FontWeight.w700,
                          )
                        : null,
                  ),
                  if (i < _kLangs.length - 1) const TextSpan(text: ' · '),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x1),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: AppColors.ink500,
          ),
        ],
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.currentCode, required this.onSelect});

  final String currentCode;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x2,
          AppSpacing.x4,
          AppSpacing.x4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final lang in _kLangs)
              InkWell(
                onTap: () => onSelect(lang.code),
                borderRadius: AppRadius.cardBorderRadius,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: AppSpacing.x4,
                  ),
                  decoration: BoxDecoration(
                    color: lang.code == currentCode ? AppColors.brandAmber.withValues(alpha: 0.08) : Colors.transparent,
                    borderRadius: AppRadius.cardBorderRadius,
                  ),
                  child: Row(
                    children: [
                      Text(lang.flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: AppSpacing.x4),
                      Expanded(
                        child: Text(
                          lang.label,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: lang.code == currentCode ? FontWeight.w700 : FontWeight.w500,
                            color: lang.code == currentCode ? AppColors.brandAmber : AppColors.ink900,
                          ),
                        ),
                      ),
                      if (lang.code == currentCode)
                        const Icon(
                          Icons.check_rounded,
                          color: AppColors.brandAmber,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
