import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterManagerScreen extends StatelessWidget {
  const RegisterManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(GetIt.I<AuthRepository>()),
      child: const _RegisterManagerView(),
    );
  }
}

class _RegisterManagerView extends StatefulWidget {
  const _RegisterManagerView();

  @override
  State<_RegisterManagerView> createState() => _RegisterManagerViewState();
}

class _RegisterManagerViewState extends State<_RegisterManagerView> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeCtr = TextEditingController();
  final _usernameCtr = TextEditingController();
  final _nameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  @override
  void dispose() {
    _inviteCodeCtr.dispose();
    _usernameCtr.dispose();
    _nameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterCubit>().registerManager(
      RegisterManagerBody(
        inviteCode: _inviteCodeCtr.text.trim(),
        username: _usernameCtr.text.trim(),
        name: _nameCtr.text.trim(),
        password: _passwordCtr.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<RegisterCubit, DataState<AuthResultModel>>(
      listener: (context, state) {
        if (state is DataSuccess) {
          context.go(AppRoutes.home);
        } else if (state is DataFailure<AuthResultModel>) {
          context.handleError(state.exception);
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          appBar: AppBar(
            leading: const BackBtn(),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterTitleWidget(
                    title: l10n.authRegisterManagerTitle,
                    badge: l10n.authManagerBadge,
                    icon: Icons.badge_outlined,
                    colorBadge: AppColors.successGreen,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: AppRadius.cardBorderRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.x4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 18),
                                  const SizedBox(width: AppSpacing.x2),
                                  Expanded(
                                    child: Text(
                                      l10n.authInviteCodeHint,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.primary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthTextField(
                            label: l10n.authInviteCodeLabel,
                            controller: _inviteCodeCtr,
                            hintText: 'TF-XXXXX',
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (v) => InputValidators.emptyValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthTextField(
                            label: l10n.authUsernameLabel,
                            controller: _usernameCtr,
                            textInputAction: TextInputAction.next,
                            validator: (v) => InputValidators.emptyValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthTextField(
                            label: l10n.authNameLabel,
                            controller: _nameCtr,
                            textInputAction: TextInputAction.next,
                            validator: (v) => InputValidators.emptyValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthPasswordField(
                            label: l10n.authPassword,
                            controller: _passwordCtr,
                            textInputAction: TextInputAction.done,
                            onSubmitted: _submit,
                            validator: (v) => InputValidators.passwordValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x6),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                    child: AuthSubmitButton(
                      label: l10n.authCreateAccount,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
