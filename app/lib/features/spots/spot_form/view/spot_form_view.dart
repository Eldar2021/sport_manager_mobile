import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

final class SpotFormExtra {
  const SpotFormExtra({
    required this.venueId,
    this.spot,
  });

  final String venueId;
  final SpotModel? spot;
}

class SpotFormView extends StatefulWidget {
  const SpotFormView(this.extra, {super.key});

  final SpotFormExtra extra;

  @override
  State<SpotFormView> createState() => _SpotFormViewState();
}

class _SpotFormViewState extends State<SpotFormView> with SpotFormViewMixin {
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra.spot != null;
    final labelStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? context.l10n.editSpotTitle : context.l10n.createSpotTitle,
          ),
          actions: [
            if (isEdit) ...[
              BlocBuilder<SpotFormCubit, SpotFormState>(
                bloc: cubit,
                buildWhen: (p, n) => p.deleteStatus.isLoading != n.deleteStatus.isLoading,
                builder: (_, state) {
                  return AppDeleteButton(
                    label: context.l10n.deleteSpotButton,
                    isLoading: state.deleteStatus.isLoading,
                    onTap: onDelete,
                  );
                },
              ),
              const SizedBox(width: AppSpacing.x4),
            ],
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.x4),
            children: [
              AppTextField(
                controller: numberCtr,
                label: context.l10n.createSpotNumberLabel,
                hintText: context.l10n.createSpotNumberHint,
                keyboardType: TextInputType.number,
                maxLength: 3,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (number) => InputValidators.emptyValidator(number, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: nameCtr,
                label: context.l10n.createSpotNameLabel,
                hintText: context.l10n.createSpotNameHint,
                validator: (name) => InputValidators.emptyValidator(name, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: descCtr,
                hintText: context.l10n.createSpotDescHint,
                label: context.l10n.createSpotDescLabel,
                validator: (desc) => InputValidators.emptyValidator(desc, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.createSpotTarifTypeLabel, style: labelStyle),
              const SizedBox(height: AppSpacing.x2),
              ValueListenableBuilder<TarifType>(
                valueListenable: tarifType,
                builder: (_, value, _) {
                  return TarifTypeSelector(
                    selected: value,
                    onChanged: (v) => tarifType.value = v,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.createSpotRateLabel, style: labelStyle),
              const SizedBox(height: AppSpacing.x2),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: rateCtr,
                builder: (_, rate, _) {
                  return RateSelector(
                    selected: int.tryParse(rate.text) ?? 200,
                    onChanged: (v) => rateCtr.text = v.toString(),
                  );
                },
              ),
              AppTextField(
                controller: rateCtr,
                keyboardType: TextInputType.number,
                maxLength: 7,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                label: '',
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.createSpotCurrencyLabel, style: labelStyle),
              const SizedBox(height: AppSpacing.x2),
              ValueListenableBuilder<Currency>(
                valueListenable: currency,
                builder: (_, value, _) {
                  return CurrencySelector(
                    selected: value,
                    onChanged: (v) => currency.value = v,
                  );
                },
              ),
              SizedBox(height: AppSpacing.bottom(context) + AppSpacing.x16),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: BlocConsumer<SpotFormCubit, SpotFormState>(
            bloc: cubit,
            listenWhen: (p, n) => p.submitStatus != n.submitStatus,
            listener: spotCubitListener,
            builder: (_, state) {
              return AppButton(
                collapseOnScroll: true,
                isLoading: state.submitStatus.isLoading,
                onPressed: onSubmit,
                child: Text(
                  isEdit ? context.l10n.updateSpotButton : context.l10n.createSpotButton,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
