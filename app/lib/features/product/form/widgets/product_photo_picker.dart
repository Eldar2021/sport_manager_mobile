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
    super.key,
  });

  final String? initialUrl;
  final bool isLoading;
  final ValueChanged<File> onPicked;

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
    return GestureDetector(
      onTap: widget.isLoading ? null : _pick,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainer,
          borderRadius: AppRadius.buttonBorderRadius,
          border: Border.all(
            color: context.colors.outlineVariant,
          ),
        ),
        child: SizedBox(
          height: 140,
          child: Center(
            child: widget.isLoading
                ? const CircularProgressIndicator.adaptive()
                : url != null
                ? ClipRRect(
                    borderRadius: AppRadius.buttonBorderRadius,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 140,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: context.colors.outline,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        context.l10n.productsPhotoPickerLabel,
                        style: context.appTextStyles.muted.bodySmall,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
