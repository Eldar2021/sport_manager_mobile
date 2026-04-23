import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ErrorBodyWidget extends StatefulWidget {
  const ErrorBodyWidget(
    this.error, {
    super.key,
    this.onRetryPressed,
  });

  final Object error;
  final VoidCallback? onRetryPressed;

  @override
  State<ErrorBodyWidget> createState() => _ErrorBodyWidgetState();
}

class _ErrorBodyWidgetState extends State<ErrorBodyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GetIt.I<ErrorHandler>().handleAuthError(widget.error, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final model = GetIt.I<ErrorHandler>().parseErrorModel(widget.error);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (model.icon != null)
              Padding(
                padding: const EdgeInsetsGeometry.all(8),
                child: model.icon,
              ),
            Text(
              model.title.getMessage(locale),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              model.message.getMessage(locale),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (widget.onRetryPressed != null)
              ElevatedButton(
                onPressed: widget.onRetryPressed,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
