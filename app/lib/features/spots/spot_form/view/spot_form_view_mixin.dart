import 'dart:async';
import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/home/home.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

mixin SpotFormViewMixin on State<SpotFormView> {
  static const defaultTarif = 200;

  late final SpotFormCubit cubit;
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
    final spot = widget.extra.spot;
    cubit = SpotFormCubit(
      GetIt.I<FacilityRepository>(),
      spot?.id,
    );
    formKey = GlobalKey<FormState>();
    nameCtr = TextEditingController(text: spot?.name ?? '');
    numberCtr = TextEditingController(text: spot?.number.toString() ?? '');
    descCtr = TextEditingController(text: spot?.description ?? '');
    rateCtr = TextEditingController(text: (spot?.tarifAmount ?? defaultTarif).toString());
    currency = ValueNotifier(spot?.currency ?? Currency.kgs);
    tarifType = ValueNotifier(spot?.tarifType ?? TarifType.hour);
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) return;
    cubit.submit(
      SpotFormParam(
        venueId: widget.extra.venueId,
        number: int.tryParse(numberCtr.text) ?? 0,
        name: nameCtr.text.trim(),
        description: descCtr.text.trim(),
        tarifAmount: int.tryParse(rateCtr.text) ?? defaultTarif,
        currency: currency.value,
        tarifType: tarifType.value,
      ),
    );
  }

  void spotCubitListener(BuildContext context, SpotFormState state) {
    if (state.submitStatus.isSuccess) {
      context.read<HomeCubit>().load();
      context.pop((state.submitStatus as RequestSuccess<SpotModel>).data);
    } else if (state.submitStatus.isFailure) {
      context.handleError((state.submitStatus as RequestFailure).exception);
    }
  }

  Future<void> onDelete() async {
    await AppDestructiveSheet.show(
      context,
      icon: Icons.delete_outline_rounded,
      title: context.l10n.deleteSpotButton,
      subtitle: context.l10n.deleteSpotSubtitle,
      confirmLabel: context.l10n.deleteSpotButton,
      onConfirm: cubit.deleteSpot,
    );
    if (!mounted) return;
    final status = cubit.state.deleteStatus;
    if (status.isSuccess) {
      unawaited(context.read<HomeCubit>().load());
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      context.pop(true);
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
