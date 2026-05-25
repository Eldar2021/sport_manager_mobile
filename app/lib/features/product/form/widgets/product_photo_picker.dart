import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductPhotoPicker extends StatefulWidget {
  const ProductPhotoPicker({
    required this.initialUrl,
    required this.isLoading,
    required this.onPicked,
    required this.onDeleted,
    this.icon,
    super.key,
  });

  final String? initialUrl;
  final bool isLoading;
  final ValueChanged<File> onPicked;
  final VoidCallback onDeleted;
  final String? icon;

  @override
  State<ProductPhotoPicker> createState() => _ProductPhotoPickerState();
}

class _ProductPhotoPickerState extends State<ProductPhotoPicker> {
  final _picker = ImagePicker();

  Future<void> _pick() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (xFile == null) return;
    widget.onPicked(File(xFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.initialUrl;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.buttonBorderRadius,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: SizedBox(
        height: 140,
        child: Center(
          child: widget.isLoading
              ? const CircularProgressIndicator.adaptive()
              : url != null
              ? _PhotoWithDelete(
                  url: url,
                  onTap: _pick,
                  onDelete: widget.onDeleted,
                )
              : GestureDetector(
                  onTap: _pick,
                  child: widget.icon != null
                      ? Text(
                          widget.icon!,
                          style: const TextStyle(fontSize: 48),
                        )
                      : _EmptyPlaceholder(context.l10n.productsPhotoPickerLabel),
                ),
        ),
      ),
    );
  }
}

class _PhotoWithDelete extends StatelessWidget {
  const _PhotoWithDelete({
    required this.url,
    required this.onTap,
    required this.onDelete,
  });

  final String url;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: AppRadius.buttonBorderRadius,
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onDelete,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: context.colors.outline,
          size: 32,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          label,
          style: context.appTextStyles.muted.bodySmall,
        ),
      ],
    );
  }
}
