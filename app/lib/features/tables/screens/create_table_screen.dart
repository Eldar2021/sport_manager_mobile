import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/components/body/app_destructive_sheet.dart';
import 'package:sport_manager_mobile/ui/components/button/app_delete_button.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:tables/tables.dart';

class CreateTableScreen extends StatefulWidget {
  const CreateTableScreen({
    required this.venueId,
    this.initialTable,
    super.key,
  });

  final String venueId;
  final TableModel? initialTable;

  @override
  State<CreateTableScreen> createState() => _CreateTableViewState();
}

class _CreateTableViewState extends State<CreateTableScreen> {
  late final CreateTableCubit _cubit;
  late final TextEditingController _nameCtr;
  late final TextEditingController _descCtr;
  late final TextEditingController _rateCtr;

  @override
  void initState() {
    super.initState();
    _cubit = CreateTableCubit(
      GetIt.I<TableRepository>(),
      widget.venueId,
      initialTable: widget.initialTable,
    );
    final table = widget.initialTable;
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
    final l10n = context.l10n;
    final labelStyle = context.textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    return BlocConsumer<CreateTableCubit, CreateTableState>(
      bloc: _cubit,
      listenWhen: _listenWhen,
      listener: _listener,
      builder: (context, state) {
        final isEdit = _cubit.isEditMode;
        return Scaffold(
          appBar: AppBar(
            title: Text(isEdit ? l10n.editTableTitle : l10n.createTableTitle),
            actions: [
              if (isEdit) ...[
                AppDeleteButton(
                  label: l10n.deleteTableButton,
                  isLoading: state.isDeleting,
                  onTap: () => AppDestructiveSheet.show(
                    context,
                    icon: Icons.delete_outline_rounded,
                    title: '${l10n.deleteTableButton} ${state.name}?',
                    subtitle: l10n.deleteTableSubtitle,
                    confirmLabel: l10n.deleteTableButton,
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
                TablePreviewCard(
                  name: state.name,
                  description: state.description,
                  hourlyRate: state.hourlyRate,
                ),
                const SizedBox(height: AppSpacing.x5),
                Text(l10n.createTableNameLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x2),
                TextField(
                  controller: _nameCtr,
                  onChanged: _cubit.updateName,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: l10n.createTableNameHint),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(l10n.createTableDescLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x2),
                TextField(
                  controller: _descCtr,
                  onChanged: _cubit.updateDescription,
                  decoration: InputDecoration(hintText: l10n.createTableDescHint),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(l10n.createTableRateLabel, style: labelStyle),
                const SizedBox(height: AppSpacing.x3),
                RateSelector(
                  selected: state.hourlyRate,
                  onChanged: (rate) => _onRateChipTap(context, rate),
                ),
                const SizedBox(height: AppSpacing.x3),
                TextField(
                  controller: _rateCtr,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.x4,
              right: AppSpacing.x4,
              bottom: AppSpacing.bottom(context),
              top: AppSpacing.x4,
            ),
            child: FilledButton(
              onPressed: state.isValid && !state.isLoading ? _cubit.submit : null,
              child: state.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: context.colors.surfaceContainer,
                      ),
                    )
                  : Text(isEdit ? l10n.updateTableButton : l10n.createTableButton),
            ),
          ),
        );
      },
    );
  }

  bool _listenWhen(CreateTableState prev, CreateTableState next) {
    return prev.submitStatus != next.submitStatus || prev.deleteStatus != next.deleteStatus;
  }

  void _listener(BuildContext context, CreateTableState state) {
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
