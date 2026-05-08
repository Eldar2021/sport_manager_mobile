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

  ReportVenueModel get _selected => venues.firstWhere(
    (v) => v.id == selectedVenueId,
    orElse: () => venues.first,
  );

  Future<void> _open(BuildContext context) async {
    final selected = await CustomSheet.open<ReportVenueModel>(
      context: context,
      title: context.l10n.reportsVenuePickerTitle,
      emptyMessage: context.l10n.homeNoVenuesTitle,
      loader: () async => venues,
      titleBuilder: (_, v) => v.name,
      subtitleBuilder: (_, v) => '#${v.number}',
      selectedItem: _selected,
    );
    if (selected != null) onSelected(selected.id);
  }

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x2),
      child: ActionChip(
        avatar: const Icon(Icons.storefront_outlined, size: 18),
        label: Text(
          _selected.name,
          style: context.textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => _open(context),
      ),
    );
  }
}
