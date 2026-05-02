import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// AppBar chip that opens a bottom sheet for selecting which venue the
/// report is scoped to. MVP: always exactly one venue selected — no
/// "All venues" aggregation.
class ReportVenuePicker extends StatelessWidget {
  const ReportVenuePicker({
    required this.venues,
    required this.selectedVenueId,
    required this.onSelected,
    super.key,
  });

  final List<ReportVenueModel> venues;
  final String? selectedVenueId;
  final ValueChanged<String> onSelected;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  context.l10n.reportsVenuePickerTitle,
                  style: context.textTheme.titleMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ),
              const Divider(height: 1),
              for (final v in venues)
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: Text(v.name),
                  subtitle: Text('#${v.number}'),
                  trailing: selectedVenueId == v.id
                      ? Icon(
                          Icons.check,
                          color: context.colors.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(v.id),
                ),
            ],
          ),
        );
      },
    );
    if (result != null) onSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) return const SizedBox.shrink();
    final selectedName = venues
        .firstWhere(
          (v) => v.id == selectedVenueId,
          orElse: () => venues.first,
        )
        .name;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x2),
      child: ActionChip(
        avatar: const Icon(Icons.storefront_outlined, size: 18),
        label: Text(
          selectedName,
          style: context.textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => _open(context),
      ),
    );
  }
}
