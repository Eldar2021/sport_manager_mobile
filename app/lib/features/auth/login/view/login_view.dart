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

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginCubit _loginCubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameCtr;
  late final TextEditingController _passwordCtr;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(GetIt.I<AuthRepository>());
    _formKey = GlobalKey<FormState>();
    _usernameCtr = TextEditingController();
    _passwordCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.x6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      style: context.appTextStyles.muted.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.x6),
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
                      validator: (v) => InputValidators.passwordValidator(v, context),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        child: Text(
                          l10n.authForgotPassword,
                          style: textTheme.bodyMedium?.copyWith(color: colors.primary),
                        ),
                        onPressed: () => context.push(AppRoutes.forgotPassword),
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
                  BlocConsumer<LoginCubit, DataState<AuthResultModel>>(
                    listener: (context, state) {
                      if (state is DataSuccess<AuthResultModel>) {
                        context.read<AuthCubit>().setAuthenticated(state.data.user);
                      } else if (state is DataFailure<AuthResultModel>) {
                        context.handleError(state.exception);
                      }
                    },
                    builder: (context, state) {
                      return AppSubmitButton(
                        label: l10n.authSignIn,
                        isLoading: state.isLoading,
                        onPressed: _login,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authNoAccount,
                        style: context.appTextStyles.muted.bodyMedium,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      TextButton(
                        child: Text(
                          l10n.authSignUp,
                          style: textTheme.bodyMedium?.copyWith(color: colors.primary),
                        ),
                        onPressed: () => context.push(AppRoutes.role),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.bottom(context)),
          ],
        ),
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    _loginCubit.login(
      _usernameCtr.text.trim(),
      _passwordCtr.text,
    );
  }

  @override
  void dispose() {
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }
}
