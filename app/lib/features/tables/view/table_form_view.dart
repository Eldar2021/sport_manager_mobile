import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
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

class _TableFormViewState extends State<TableFormView> {
  static const _defaultTarif = 200;
  late final TableFormCubit _cubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _numberCtr;
  late final TextEditingController _nameCtr;
  late final TextEditingController _descCtr;
  late final TextEditingController _rateCtr;
  late final Currency _currency;
  late final TarifType _tarifType;

  @override
  void initState() {
    super.initState();
    final table = widget.extra.table;
    _cubit = TableFormCubit(
      GetIt.I<FacilityRepository>(),
      widget.extra.venueId,
      initialTable: table,
    );
    _formKey = GlobalKey<FormState>();
    _nameCtr = TextEditingController(text: table?.name ?? '');
    _numberCtr = TextEditingController(text: table?.number.toString() ?? '');
    _descCtr = TextEditingController(text: table?.description ?? '');
    _rateCtr = TextEditingController(text: (table?.tarifAmount ?? _defaultTarif).toString());
    _currency = table?.currency ?? Currency.kgs;
    _tarifType = table?.tarifType ?? TarifType.hour;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra.table != null;
    final labelStyle = context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);

    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEdit ? context.l10n.editTableTitle : context.l10n.createTableTitle,
          ),
          actions: [
            if (isEdit) ...[
              BlocConsumer<TableFormCubit, TableFormState>(
                bloc: _cubit,
                listenWhen: (p, n) => p.deleteStatus != n.deleteStatus,
                listener: (context, state) {
                  if (state.deleteStatus.isSuccess) {
                    context.pop();
                  } else if (state.deleteStatus.isFailure) {
                    context.handleError((state.deleteStatus as RequestFailure).exception);
                  }
                },
                buildWhen: (p, n) => p.isDeleting != n.isDeleting,
                builder: (_, state) {
                  return AppDeleteButton(
                    label: context.l10n.deleteTableButton,
                    isLoading: state.isDeleting,
                    onTap: () => AppDestructiveSheet.show(
                      context,
                      icon: Icons.delete_outline_rounded,
                      title: context.l10n.deleteTableButton,
                      subtitle: context.l10n.deleteTableSubtitle,
                      confirmLabel: context.l10n.deleteTableButton,
                      onConfirm: _cubit.deleteTable,
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.x4),
            ],
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _numberCtr,
                  label: context.l10n.createTableNumberLabel,
                  hintText: context.l10n.createTableNumberHint,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (number) => InputValidators.emptyValidator(number, context),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _nameCtr,
                  label: context.l10n.createTableNameLabel,
                  hintText: context.l10n.createTableNameHint,
                  validator: (name) => InputValidators.emptyValidator(name, context),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppTextField(
                  controller: _descCtr,
                  hintText: context.l10n.createTableDescHint,
                  label: context.l10n.createTableDescLabel,
                  validator: (desc) => InputValidators.emptyValidator(desc, context),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(context.l10n.createTableTarifTypeLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x2),
                TarifTypeSelector(
                  selected: _tarifType,
                  onChanged: (value) {
                    setState(() {});
                    _tarifType = value;
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(context.l10n.createTableRateLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x2),
                RateSelector(
                  selected: _rateCtr.text,
                  onChanged: (value) => _rateCtr.text = value,
                ),
                AppTextField(
                  controller: _rateCtr,
                  keyboardType: TextInputType.number,
                  maxLength: 7,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  label: '',
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(context.l10n.createTableCurrencyLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x2),
                CurrencySelector(
                  selected: _currency,
                  onChanged: (currency) {
                    _currency = currency;
                    setState(() {});
                  },
                ),
                SizedBox(height: AppSpacing.bottom(context) + AppSpacing.x16),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: BlocConsumer<TableFormCubit, TableFormState>(
            bloc: _cubit,
            listenWhen: (p, n) => p.submitStatus != n.submitStatus,
            listener: (context, state) {
              if (state.submitStatus.isSuccess) {
                context.pop();
              } else if (state.submitStatus.isFailure) {
                context.handleError((state.submitStatus as RequestFailure).exception);
              }
            },
            builder: (_, state) => AppButton(
              collapseOnScroll: true,
              isLoading: state.isLoading,
              onPressed: _onSubmit,
              child: Text(
                isEdit ? context.l10n.updateTableButton : context.l10n.createTableButton,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final param = TableFormParam(
      number: int.tryParse(_numberCtr.text) ?? 0,
      name: _nameCtr.text.trim(),
      description: _descCtr.text.trim(),
      tarifAmount: int.tryParse(_rateCtr.text) ?? _defaultTarif,
      currency: _currency,
      tarifType: _tarifType,
    );

    _cubit.submit(param);
  }

  @override
  void dispose() {
    _cubit.close();
    _nameCtr.dispose();
    _numberCtr.dispose();
    _descCtr.dispose();
    _rateCtr.dispose();
    super.dispose();
  }
}
