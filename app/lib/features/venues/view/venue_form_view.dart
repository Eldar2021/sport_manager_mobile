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

class VenueFormView extends StatefulWidget {
  const VenueFormView({this.venue, super.key});

  final VenueModel? venue;

  @override
  State<VenueFormView> createState() => _VenueFormViewState();
}

class _VenueFormViewState extends State<VenueFormView> {
  late final VenueFormCubit _cubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameCtr;
  late final TextEditingController _numberCtr;

  @override
  void initState() {
    super.initState();
    _cubit = VenueFormCubit(
      GetIt.I<VenueRepository>(),
      venueId: widget.venue?.id,
    );
    _formKey = GlobalKey<FormState>();
    _nameCtr = TextEditingController(text: widget.venue?.name ?? '');
    _numberCtr = TextEditingController(text: widget.venue?.number ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.venue != null;

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(title: Text(isEdit ? context.l10n.editVenueTitle : context.l10n.createVenueTitle)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x4,
            AppSpacing.x10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameCtr,
                  label: context.l10n.createVenueNameLabel,
                  hintText: context.l10n.createVenueNameHint,
                  validator: (v) => InputValidators.emptyValidator(v, context),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _numberCtr,
                  label: context.l10n.createVenueNumberLabel,
                  hintText: context.l10n.createVenueNumberHint,
                  validator: (v) => InputValidators.emptyValidator(v, context),
                  keyboardType: TextInputType.number,
                ),
                if (!isEdit) ...[
                  const SizedBox(height: AppSpacing.x5),
                  AppBanner(context.l10n.createVenueInfoBanner),
                ],
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: BlocConsumer<VenueFormCubit, VenueFormState>(
            bloc: _cubit,
            listenWhen: (prev, next) => prev.reqStatus != next.reqStatus,
            listener: (context, state) {
              if (state.reqStatus.isSuccess) {
                context.pop();
              } else if (state.reqStatus.isFailure) {
                context.handleError((state.reqStatus as RequestFailure).exception);
              }
            },
            builder: (context, state) {
              return AppButton(
                collapseOnScroll: true,
                onPressed: _submitForm,
                isLoading: state.isLoading,
                child: Text(isEdit ? context.l10n.updateVenueButton : context.l10n.createVenueButton),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _cubit.submit(
      _nameCtr.text,
      _numberCtr.text,
    );
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _numberCtr.dispose();
    _cubit.close();
    super.dispose();
  }
}
