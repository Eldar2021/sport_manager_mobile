import 'package:flutter/material.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Chip displayed in the AppBar that opens a bottom sheet for selecting
/// a venue (or "All venues") to filter the report by.
class ReportVenuePicker extends StatelessWidget {
  const ReportVenuePicker({
    required this.venues,
    required this.selectedVenueId,
    required this.onSelected,
    super.key,
  });

  final List<ReportVenueModel> venues;
  final String? selectedVenueId;
  final ValueChanged<String?> onSelected;

  Future<void> _open(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showModalBottomSheet<_VenueChoice>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.reportsVenuePickerTitle,
                  style: context.textTheme.titleMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.apps_rounded),
                title: Text(l10n.reportsAllVenues),
                trailing: selectedVenueId == null ? Icon(Icons.check, color: context.colors.primary) : null,
                onTap: () => Navigator.of(context).pop(const _VenueChoice(null)),
              ),
              for (final v in venues)
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: Text(v.name),
                  subtitle: Text('#${v.number}'),
                  trailing: selectedVenueId == v.id ? Icon(Icons.check, color: context.colors.primary) : null,
                  onTap: () => Navigator.of(context).pop(_VenueChoice(v.id)),
                ),
            ],
          ),
        );
      },
    );
    if (result != null) onSelected(result.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = selectedVenueId == null
        ? l10n.reportsAllVenues
        : venues
              .firstWhere(
                (v) => v.id == selectedVenueId,
                orElse: () => ReportVenueModel(id: '', name: l10n.reportsAllVenues, number: 0),
              )
              .name;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x2),
      child: ActionChip(
        avatar: const Icon(Icons.storefront_outlined, size: 18),
        label: Text(
          selected,
          style: context.textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => _open(context),
      ),
    );
  }
}

class _VenueChoice {
  const _VenueChoice(this.id);
  final String? id;
}
