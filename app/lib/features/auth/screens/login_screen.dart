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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(GetIt.I<AuthRepository>()),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginCubit>().login(
      username: _usernameCtr.text.trim(),
      password: _passwordCtr.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<LoginCubit, DataState<AuthResultModel>>(
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x6,
                      vertical: AppSpacing.x4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.authSignIn,
                          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          l10n.authSignInSubtitle,
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.x6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthTextField(
                            label: l10n.authUsernameOrEmail,
                            controller: _usernameCtr,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
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
                          const SizedBox(height: AppSpacing.x3),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AuthTextButton(
                              label: l10n.authForgotPassword,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthSubmitButton(
                          label: l10n.authSignIn,
                          onPressed: _submit,
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.authNoAccount,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(width: AppSpacing.x1),
                            AuthTextButton(
                              label: l10n.authSignUp,
                              onPressed: () => context.push(AppRoutes.role),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
