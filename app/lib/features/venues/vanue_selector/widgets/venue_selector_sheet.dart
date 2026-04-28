import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
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
  late final VenuesCubit _cubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = VenuesCubit(GetIt.I<FacilityRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
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
                  onPressed: context.pop,
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

          BlocBuilder<VenuesCubit, DataState<List<VenueModel>>>(
            bloc: _cubit,
            builder: (context, state) {
              return switch (state) {
                DataInitial() || DataLoading() => const Center(child: CircularProgressIndicator()),
                DataFailure(:final exception) => ErrorBodyWidget(
                  exception,
                  onRetryPressed: _cubit.load,
                ),
                DataSuccess(:final data) => ListView.separated(
                  controller: _scrollController,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.x2),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return VenueItem(
                      venue: item,
                      isSelected: widget.selectedVenue?.id == item.id,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onSelect(item);
                      },
                    );
                  },
                ),
              };
            },
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
          SizedBox(height: AppSpacing.bottom(context)),
        ],
      ),
    );
  }
}
