import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      color: colorScheme.primary,
      onPressed: onBack ?? () => context.pop(),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}
