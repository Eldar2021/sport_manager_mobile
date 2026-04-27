import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:tables/tables.dart';

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
  late final TableFormCubit _cubit;
  late final TextEditingController _nameCtr;
  late final TextEditingController _descCtr;
  late final TextEditingController _rateCtr;

  @override
  void initState() {
    super.initState();
    _cubit = TableFormCubit(
      GetIt.I<TableRepository>(),
      widget.extra.venueId,
      initialTable: widget.extra.table,
    );
    final table = widget.extra.table;
    _nameCtr = TextEditingController(text: table?.name ?? '');
    _descCtr = TextEditingController(text: table?.description ?? '');
    _rateCtr = TextEditingController(text: (table?.hourlyRate ?? 200).toString());
  }

  void _onRateChipTap(BuildContext context, int rate) {
    _cubit.updateRate(rate);
    if (_rateCtr.text != rate.toString()) {
      _rateCtr
        ..text = rate.toString()
        ..selection = TextSelection.collapsed(offset: rate.toString().length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.extra.table != null;
    final labelStyle = context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? context.l10n.editTableTitle : context.l10n.createTableTitle),
          actions: [
            if (isEdit) ...[
              AppDeleteButton(
                label: context.l10n.deleteTableButton,
                isLoading: _cubit.state.isDeleting,
                onTap: () => AppDestructiveSheet.show(
                  context,
                  icon: Icons.delete_outline_rounded,
                  title: '${context.l10n.deleteTableButton} ${_cubit.state.name}?',
                  subtitle: context.l10n.deleteTableSubtitle,
                  confirmLabel: context.l10n.deleteTableButton,
                  onConfirm: _cubit.deleteTable,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
            ],
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<TableFormCubit, TableFormState>(
                bloc: _cubit,
                buildWhen: (prev, next) =>
                    prev.name != next.name ||
                    prev.description != next.description ||
                    prev.hourlyRate != next.hourlyRate,
                builder: (context, state) {
                  return TablePreviewCard(
                    name: state.name,
                    description: state.description,
                    hourlyRate: state.hourlyRate,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.x5),
              AppTextField(
                controller: _nameCtr,
                onChanged: _cubit.updateName,
                label: context.l10n.createTableNameLabel,
                hintText: context.l10n.createTableNameHint,
              ),
              const SizedBox(height: AppSpacing.x4),
              AppTextField(
                controller: _descCtr,
                onChanged: _cubit.updateDescription,
                hintText: context.l10n.createTableDescHint,
                label: context.l10n.createTableDescLabel,
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(context.l10n.createTableRateLabel, style: labelStyle),
              const SizedBox(height: AppSpacing.x2),
              RateSelector(
                selected: _cubit.state.hourlyRate,
                onChanged: (rate) => _onRateChipTap(context, rate),
              ),
              AppTextField(
                controller: _rateCtr,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                label: '',
                onChanged: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed > 0) {
                    _cubit.updateRate(parsed);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.x10),
            ],
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: BlocConsumer<TableFormCubit, TableFormState>(
            bloc: _cubit,
            listenWhen: _listenWhen,
            listener: _listener,
            builder: (_, state) {
              return AppButton(
                collapseOnScroll: true,
                onPressed: state.isValid ? _cubit.submit : null,
                isLoading: state.isLoading,
                child: Text(isEdit ? context.l10n.updateTableButton : context.l10n.createTableButton),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _listenWhen(TableFormState prev, TableFormState next) {
    return prev.submitStatus != next.submitStatus || prev.deleteStatus != next.deleteStatus;
  }

  void _listener(BuildContext context, TableFormState state) {
    if (state.submitStatus.isSuccess || state.deleteStatus.isSuccess) {
      context.pop();
    } else if (state.submitStatus.isFailure) {
      context.handleError((state.submitStatus as RequestFailure).exception);
    } else if (state.deleteStatus.isFailure) {
      context.handleError((state.deleteStatus as RequestFailure).exception);
    }
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _descCtr.dispose();
    _rateCtr.dispose();
    super.dispose();
  }
}
