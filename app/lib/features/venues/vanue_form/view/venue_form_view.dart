import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

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
  bool _typeError = false;

  bool get _isEdit => widget.venue != null;

  @override
  void initState() {
    super.initState();
    _cubit = VenueFormCubit(
      repository: GetIt.I<FacilityRepository>(),
      venue: widget.venue,
    );
    _formKey = GlobalKey<FormState>();
    _nameCtr = TextEditingController(text: widget.venue?.name ?? '');
    _numberCtr = TextEditingController(text: (widget.venue?.number ?? 0).toString());
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? context.l10n.editVenueTitle : context.l10n.createVenueTitle,
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x10,
            ),
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
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.venueFormTypeLabel, style: labelStyle),
              const SizedBox(height: AppSpacing.x2),
              BlocBuilder<VenueFormCubit, VenueFormState>(
                bloc: _cubit,
                buildWhen: (p, n) => p.selectedType != n.selectedType,
                builder: (_, state) => VenueTypePicker(
                  selected: state.selectedType,
                  enabled: !_isEdit,
                  onChanged: (type) {
                    setState(() => _typeError = false);
                    _cubit.selectType(type);
                  },
                ),
              ),
              if (_isEdit)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x2),
                  child: Text(
                    context.l10n.venueFormTypeImmutableHint,
                    style: context.appTextStyles.muted.bodySmall,
                  ),
                ),
              if (_typeError)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x2),
                  child: Text(
                    context.l10n.venueFormTypeRequiredError,
                    style: context.appTextStyles.error.bodySmall,
                  ),
                ),
              if (!_isEdit) ...[
                const SizedBox(height: AppSpacing.x5),
                AppBanner(context.l10n.createVenueInfoBanner),
              ],
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: BlocConsumer<VenueFormCubit, VenueFormState>(
            bloc: _cubit,
            listenWhen: (prev, next) => prev.reqStatus != next.reqStatus,
            listener: (context, state) async {
              final status = state.reqStatus;
              if (status is RequestSuccess<VenueModel>) {
                await context.read<HomeCubit>().selectVenue(status.data.id);
                if (!context.mounted) return;
                context.pop(status.data);
              } else if (status is RequestFailure<VenueModel>) {
                context.handleError(status.exception);
              }
            },
            builder: (context, state) {
              return AppButton(
                collapseOnScroll: true,
                onPressed: _submitForm,
                isLoading: state.isLoading,
                child: Text(
                  _isEdit ? context.l10n.updateVenueButton : context.l10n.createVenueButton,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final selectedType = _cubit.state.selectedType;
    if (selectedType == null) {
      setState(() => _typeError = true);
      _formKey.currentState!.validate();
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final number = int.tryParse(_numberCtr.text.trim()) ?? 0;
    _cubit.submit(
      VenueFormParam(
        name: _nameCtr.text,
        number: number,
        type: selectedType,
      ),
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
