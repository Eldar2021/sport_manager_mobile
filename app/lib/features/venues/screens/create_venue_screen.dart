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
  late final CreateVenueCubit _cubit;
  final _nameCtr = TextEditingController();
  final _numberCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = CreateVenueCubit(GetIt.I<VenueRepository>());
  }

  @override
  void dispose() {
    _cubit.close();
    _nameCtr.dispose();
    _numberCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CreateVenueCubit, CreateVenueState>(
        listener: (context, state) {
          if (state.submitStatus is RequestSuccess) {
            context.pop();
          } else if (state.submitStatus is RequestFailure) {
            context.handleError((state.submitStatus as RequestFailure).exception);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackBtn(),
              title: Text(l10n.createVenueTitle),
            ),
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
                  Text(
                    l10n.createVenueSubtitle,
                    style: AppTypography.body.copyWith(color: AppColors.ink700),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Text(
                    l10n.createVenueNameLabel,
                    style: AppTypography.caption.copyWith(color: AppColors.ink500),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  TextField(
                    controller: _nameCtr,
                    onChanged: _cubit.updateName,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(hintText: l10n.createVenueNameHint),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    l10n.createVenueNumberLabel,
                    style: AppTypography.caption.copyWith(color: AppColors.ink500),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  TextField(
                    controller: _numberCtr,
                    onChanged: _cubit.updateNumber,
                    decoration: InputDecoration(hintText: l10n.createVenueNumberHint),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  AppInfoBanner(text: l10n.createVenueInfoBanner),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  AppSpacing.x2,
                  AppSpacing.x4,
                  AppSpacing.x4,
                ),
                child: FilledButton(
                  onPressed: state.isValid && !state.isLoading ? _cubit.createVenue : null,
                  child: state.isLoading
                      ? const AppActivityIndicator(color: AppColors.white)
                      : Text(l10n.createVenueButton),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
