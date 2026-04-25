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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginScreen> {
  late final LoginCubit _loginCubit;
  final _usernameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(GetIt.I<AuthRepository>());
  }

  @override
  void dispose() {
    _loginCubit.close();
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.isSuccess) {
          context.go(AppRoutes.home);
        } else if (state.isFailure) {
          context.handleError(state.status);
        }
      },
      buildWhen: (p, c) => p.isLoading != c.isLoading || p.canSubmit != c.canSubmit,
      builder: (context, state) => Scaffold(
        appBar: AppBar(leading: const BackBtn()),
        body: SafeArea(
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
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      l10n.authSignInSubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
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
                        onChanged: _loginCubit.usernameChanged,
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      AuthPasswordField(
                        label: l10n.authPassword,
                        controller: _passwordCtr,
                        textInputAction: TextInputAction.done,
                        onChanged: _loginCubit.passwordChanged,
                        onSubmitted: _loginCubit.login,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AuthTextButton(
                          label: l10n.authForgotPassword,
                          onPressed: () => context.push(AppRoutes.forgotPassword),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthSubmitButton(
                      label: l10n.authSignIn,
                      isLoading: state.isLoading,
                      onPressed: state.canSubmit ? _loginCubit.login : null,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authNoAccount,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
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
  }
}
