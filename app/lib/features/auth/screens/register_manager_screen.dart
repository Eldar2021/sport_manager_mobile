import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterManagerScreen extends StatefulWidget {
  const RegisterManagerScreen({super.key});

  @override
  State<RegisterManagerScreen> createState() => _RegisterManagerViewState();
}

class _RegisterManagerViewState extends State<RegisterManagerScreen> {
  late final RegisterManagerCubit _registerManagerCubit;
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeCtr = TextEditingController();
  final _usernameCtr = TextEditingController();
  final _nameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerManagerCubit = RegisterManagerCubit(
      GetIt.I<AuthRepository>(),
      context.read<AuthCubit>(),
    );
  }

  @override
  void dispose() {
    _registerManagerCubit.close();
    _inviteCodeCtr.dispose();
    _usernameCtr.dispose();
    _nameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  void _registerManager() {
    if (!_formKey.currentState!.validate()) return;
    _registerManagerCubit.registerManager(
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

    return Scaffold(
      appBar: AppBar(leading: const BackBtn()),
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
                        validator: (v) => InputValidators.passwordValidator(v, context),
                      ),
                      const SizedBox(height: AppSpacing.x6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                child: BlocConsumer<RegisterManagerCubit, DataState<void>>(
                  bloc: _registerManagerCubit,
                  listener: (context, state) {
                    if (state.isFailure) {
                      final exception = (state as DataFailure<void>).exception;
                      context.handleError(exception);
                    }
                  },
                  builder: (context, state) {
                    return AuthSubmitButton(
                      label: l10n.authCreateAccount,
                      isLoading: state.isLoading,
                      onPressed: _registerManager,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
            ],
          ),
        ),
      ),
    );
  }
}
