import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueTypePicker extends StatelessWidget {
  const VenueTypePicker({
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final VenueType? selected;
  final ValueChanged<VenueType> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final type in VenueType.values)
          ChoiceChip(
            avatar: Icon(
              type.icon,
              size: 18,
              color: type == selected ? context.colors.onPrimary : context.colors.onSurfaceVariant,
            ),
            label: Text(type.typeName(context)),
            selected: type == selected,
            onSelected: enabled ? (_) => onChanged(type) : null,
          ),
      ],
    );
  }
}
