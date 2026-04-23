import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    this.title,
    this.description,
    super.key,
  });

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Assets.icons.search.svg(
            //   width: 60,
            //   height: 60,
            // ),
            const SizedBox(height: 16),
            Text(
              title ?? 'Nothing was found',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description ?? 'Nothing found for your request.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
