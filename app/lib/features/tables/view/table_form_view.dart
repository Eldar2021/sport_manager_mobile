import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

final class TableFormExtra {
  const TableFormExtra({
    required this.venueId,
    this.table,
  });

  final String venueId;
  final TableModel? table;
}

class TableFormView extends StatefulWidget {
  const TableFormView(this.extra, {super.key});

  final TableFormExtra extra;

  @override
  State<TableFormView> createState() => _TableFormViewState();
}

class _TableFormViewState extends State<TableFormView> with TableFormViewMixin {
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra.table != null;
    final labelStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? context.l10n.editTableTitle : context.l10n.createTableTitle,
          ),
          actions: [
            if (isEdit) ...[
              BlocConsumer<TableFormCubit, TableFormState>(
                bloc: cubit,
                listenWhen: (p, n) => p.deleteStatus != n.deleteStatus,
                listener: listenerDelete,
                buildWhen: (p, n) => p.deleteStatus.isLoading != n.deleteStatus.isLoading,
                builder: (_, state) {
                  return AppDeleteButton(
                    label: context.l10n.deleteTableButton,
                    isLoading: state.deleteStatus.isLoading,
                    onTap: () => AppDestructiveSheet.show(
                      context,
                      icon: Icons.delete_outline_rounded,
                      title: context.l10n.deleteTableButton,
                      subtitle: context.l10n.deleteTableSubtitle,
                      confirmLabel: context.l10n.deleteTableButton,
                      onConfirm: cubit.deleteTable,
                    ),
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
                label: context.l10n.createTableNumberLabel,
                hintText: context.l10n.createTableNumberHint,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (number) => InputValidators.emptyValidator(number, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: nameCtr,
                label: context.l10n.createTableNameLabel,
                hintText: context.l10n.createTableNameHint,
                validator: (name) => InputValidators.emptyValidator(name, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: descCtr,
                hintText: context.l10n.createTableDescHint,
                label: context.l10n.createTableDescLabel,
                validator: (desc) => InputValidators.emptyValidator(desc, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.createTableTarifTypeLabel, style: labelStyle),
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
              Text(context.l10n.createTableRateLabel, style: labelStyle),
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
              Text(context.l10n.createTableCurrencyLabel, style: labelStyle),
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: BlocConsumer<TableFormCubit, TableFormState>(
            bloc: cubit,
            listenWhen: (p, n) => p.submitStatus != n.submitStatus,
            listener: tableCubitListener,
            builder: (_, state) {
              return AppButton(
                collapseOnScroll: true,
                isLoading: state.submitStatus.isLoading,
                onPressed: onSubmit,
                child: Text(
                  isEdit ? context.l10n.updateTableButton : context.l10n.createTableButton,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
