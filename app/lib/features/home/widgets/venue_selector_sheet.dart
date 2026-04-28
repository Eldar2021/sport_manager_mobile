import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenueSelectorSheet extends StatefulWidget {
  const VenueSelectorSheet({
    required this.selectedVenue,
    required this.onSelect,
    this.isOwner = false,
    super.key,
  });

  final VenueModel? selectedVenue;
  final ValueChanged<VenueModel> onSelect;
  final bool isOwner;

  static Future<void> show(
    BuildContext context, {
    required VenueModel? selectedVenue,
    required ValueChanged<VenueModel> onSelect,
    bool isOwner = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => VenueSelectorSheet(
        selectedVenue: selectedVenue,
        onSelect: onSelect,
        isOwner: isOwner,
      ),
    );
  }

  @override
  State<VenueSelectorSheet> createState() => _VenueSelectorSheetState();
}

class _VenueSelectorSheetState extends State<VenueSelectorSheet> {
  late final VenuePickerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VenuePickerCubit(GetIt.I<FacilityRepository>())..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.65;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
            child: Row(
              children: [
                Text(context.l10n.homeSelectVenue, style: context.textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: context.colors.surfaceContainerHigh,
                    foregroundColor: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Flexible(
            child: BlocBuilder<VenuePickerCubit, DataState<List<VenueModel>>>(
              bloc: _cubit,
              builder: (context, state) => switch (state) {
                DataInitial() || DataLoading() => const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.x6),
                  child: Center(child: AppActivityIndicator()),
                ),
                DataFailure(:final exception) => ErrorBodyWidget(
                  exception,
                  onRetryPressed: _cubit.load,
                ),
                DataSuccess(:final data) => ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final venue = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
                      child: _VenueItem(
                        venue: venue,
                        isSelected: widget.selectedVenue?.id == venue.id,
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelect(venue);
                        },
                      ),
                    );
                  },
                ),
              },
            ),
          ),
          if (widget.isOwner) ...[
            const SizedBox(height: AppSpacing.x4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: AppOutlinedButton(
                title: context.l10n.homeNewVenue,
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.venueForm);
                },
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x6),
        ],
      ),
    );
  }
}

class _VenueItem extends StatelessWidget {
  const _VenueItem({
    required this.venue,
    required this.isSelected,
    required this.onTap,
  });

  final VenueModel venue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: isSelected ? context.colors.primaryContainer : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      leading: SizedBox(
        width: 40,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? context.colors.primary : context.colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              Icons.location_on_outlined,
              color: isSelected ? context.colors.onPrimary : context.colors.onSurfaceVariant,
              size: 18,
            ),
          ),
        ),
      ),
      title: Text(
        venue.name,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: context.colors.onSurface,
        ),
      ),
      subtitle: Text(
        '№ ${venue.number}',
        style: context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
      ),
      trailing: isSelected ? Icon(Icons.check_rounded, color: context.colors.primary) : null,
    );
  }
}
