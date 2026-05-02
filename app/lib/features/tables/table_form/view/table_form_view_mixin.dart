import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

mixin TableFormViewMixin on State<TableFormView> {
  static const defaultTarif = 200;

  late final TableFormCubit cubit;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController numberCtr;
  late final TextEditingController nameCtr;
  late final TextEditingController descCtr;
  late final TextEditingController rateCtr;
  late final ValueNotifier<Currency> currency;
  late final ValueNotifier<TarifType> tarifType;

  @override
  void initState() {
    super.initState();
    final table = widget.extra.table;
    cubit = TableFormCubit(
      GetIt.I<FacilityRepository>(),
      widget.extra.venueId,
      table?.id,
    );
    formKey = GlobalKey<FormState>();
    nameCtr = TextEditingController(text: table?.name ?? '');
    numberCtr = TextEditingController(text: table?.number.toString() ?? '');
    descCtr = TextEditingController(text: table?.description ?? '');
    rateCtr = TextEditingController(text: (table?.tarifAmount ?? defaultTarif).toString());
    currency = ValueNotifier(table?.currency ?? Currency.kgs);
    tarifType = ValueNotifier(table?.tarifType ?? TarifType.hour);
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) return;
    cubit.submit(
      TableFormParam(
        number: int.tryParse(numberCtr.text) ?? 0,
        name: nameCtr.text.trim(),
        description: descCtr.text.trim(),
        tarifAmount: int.tryParse(rateCtr.text) ?? defaultTarif,
        currency: currency.value,
        tarifType: tarifType.value,
      ),
    );
  }

  void tableCubitListener(BuildContext context, TableFormState state) {
    if (state.submitStatus.isSuccess) {
      context.pop(true);
    } else if (state.submitStatus.isFailure) {
      context.handleError((state.submitStatus as RequestFailure).exception);
    }
  }

  Future<void> onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteTableButton,
      subtitle: context.l10n.deleteTableSubtitle,
      confirmLabel: context.l10n.deleteTableButton,
      onConfirm: cubit.deleteTable,
    );
    if (!mounted) return;
    final status = cubit.state.deleteStatus;
    if (status.isSuccess) {
      context.pop();
    } else if (status is RequestFailure<bool>) {
      context.handleError(status.exception);
    }
  }

  @override
  void dispose() {
    cubit.close();
    nameCtr.dispose();
    numberCtr.dispose();
    descCtr.dispose();
    rateCtr.dispose();
    currency.dispose();
    tarifType.dispose();
    super.dispose();
  }
}
