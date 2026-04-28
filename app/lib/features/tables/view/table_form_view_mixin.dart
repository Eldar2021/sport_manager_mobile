import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';

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
      context.pop();
    } else if (state.submitStatus.isFailure) {
      context.handleError((state.submitStatus as RequestFailure).exception);
    }
  }

  void listenerDelete(BuildContext context, TableFormState state) {
    if (state.deleteStatus.isSuccess) {
      context.pop();
    } else if (state.deleteStatus.isFailure) {
      context.handleError((state.deleteStatus as RequestFailure).exception);
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
