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
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _inviteCodeCtr;
  late final TextEditingController _usernameCtr;
  late final TextEditingController _nameCtr;
  late final TextEditingController _passwordCtr;

  @override
  void initState() {
    super.initState();
    _registerManagerCubit = RegisterManagerCubit(GetIt.I<AuthRepository>());
    _formKey = GlobalKey<FormState>();
    _inviteCodeCtr = TextEditingController();
    _usernameCtr = TextEditingController();
    _nameCtr = TextEditingController();
    _passwordCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.authRegisterManagerTitle,
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    RoleBadge(
                      label: l10n.authManagerBadge,
                      color: context.appColors.success,
                      bg: context.appColors.success.withValues(alpha: AppOpacity.tint),
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    HintBanner(l10n.authInviteCodeHint),
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
              child: BlocConsumer<RegisterManagerCubit, DataState<AuthResultModel>>(
                bloc: _registerManagerCubit,
                listener: (context, state) {
                  if (state is DataSuccess<AuthResultModel>) {
                    context.read<AuthCubit>().setAuthenticated(state.data.user);
                  } else if (state is DataFailure<AuthResultModel>) {
                    context.handleError(state.exception);
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
            SizedBox(height: AppSpacing.bottom(context)),
          ],
        ),
      ),
    );
  }

  void _registerManager() {
    if (!_formKey.currentState!.validate()) return;
    _registerManagerCubit.registerManager(
      RegisterManagerBody(
        inviteCode: _inviteCodeCtr.text.trim(),
        username: _usernameCtr.text.trim(),
        name: _nameCtr.text.trim(),
        password: _passwordCtr.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _registerManagerCubit.close();
    _inviteCodeCtr.dispose();
    _usernameCtr.dispose();
    _nameCtr.dispose();
    _passwordCtr.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }
}
