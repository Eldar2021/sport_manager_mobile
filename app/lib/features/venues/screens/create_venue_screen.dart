import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:venues/venues.dart';

class CreateVenueScreen extends StatefulWidget {
  const CreateVenueScreen({super.key});

  @override
  State<CreateVenueScreen> createState() => _CreateVenueScreenState();
}

class _CreateVenueScreenState extends State<CreateVenueScreen> {
  late final CreateVenueCubit _createVenueCubit;
  late final TextEditingController _nameCtr;
  late final TextEditingController _numberCtr;

  @override
  void initState() {
    super.initState();
    _createVenueCubit = CreateVenueCubit(GetIt.I<VenueRepository>());
    _nameCtr = TextEditingController();
    _numberCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createVenueTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x4,
          AppSpacing.x4,
          AppSpacing.x10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.createVenueSubtitle, style: labelStyle),
            const SizedBox(height: AppSpacing.x5),
            Text(l10n.createVenueNameLabel, style: labelStyle),
            const SizedBox(height: AppSpacing.x2),
            TextField(
              controller: _nameCtr,
              onChanged: _createVenueCubit.updateName,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.createVenueNameHint),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(l10n.createVenueNumberLabel, style: labelStyle),
            const SizedBox(height: AppSpacing.x2),
            TextField(
              controller: _numberCtr,
              onChanged: _createVenueCubit.updateNumber,
              decoration: InputDecoration(hintText: l10n.createVenueNumberHint),
            ),
            const SizedBox(height: AppSpacing.x5),
            AppInfoBanner(l10n.createVenueInfoBanner),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x2,
          AppSpacing.x4,
          AppSpacing.bottom(context),
        ),
        child: BlocConsumer<CreateVenueCubit, CreateVenueState>(
          bloc: _createVenueCubit,
          listenWhen: (prev, next) => prev.submitStatus != next.submitStatus,
          listener: (context, state) {
            if (state.submitStatus is RequestSuccess) {
              context.pop();
            } else if (state.submitStatus is RequestFailure) {
              context.handleError((state.submitStatus as RequestFailure).exception);
            }
          },
          builder: (context, state) {
            return FilledButton(
              onPressed: state.isValid && !state.isLoading ? _createVenueCubit.createVenue : null,
              child: state.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    )
                  : Text(l10n.createVenueButton),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _numberCtr.dispose();
    super.dispose();
  }
}
