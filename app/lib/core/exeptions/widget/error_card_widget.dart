import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ErrorCardWudget extends StatelessWidget {
  const ErrorCardWudget(this.error, {super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final model = GetIt.I<ErrorHandler>().parseErrorModel(error);
    return Column(
      children: [
        if (model.icon != null)
          Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: model.icon,
          ),
        Text(
          model.title.getMessage(locale),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          model.message.getMessage(locale),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
