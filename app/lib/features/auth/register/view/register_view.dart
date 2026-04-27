import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    required this.role,
    super.key,
  });

  final UserRole role;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final RegisterCubit _registerCubit;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameCtr;
  late final TextEditingController _phoneCtr;
  late final TextEditingController _emailCtr;
  late final TextEditingController _passwordCtr;
  late final TextEditingController _confirmCtr;
  late final TextEditingController _inviteCodeCtr;

  bool get _isOwner => widget.role == UserRole.owner;

  @override
  void initState() {
    super.initState();
    _registerCubit = RegisterCubit(GetIt.I<AuthRepository>());
    _formKey = GlobalKey<FormState>();
    _nameCtr = TextEditingController();
    _phoneCtr = TextEditingController();
    _emailCtr = TextEditingController();
    _passwordCtr = TextEditingController();
    _confirmCtr = TextEditingController();
    _inviteCodeCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                      _isOwner ? context.l10n.authRegisterOwnerTitle : context.l10n.authRegisterManagerTitle,
                      style: context.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    if (_isOwner)
                      RoleBadge(
                        label: context.l10n.authOwnerBadge,
                        color: context.colors.primary,
                        icon: Icons.business_center_rounded,
                      )
                    else
                      RoleBadge(
                        label: context.l10n.authManagerBadge,
                        color: context.appColors.success,
                        icon: Icons.badge_outlined,
                      ),
                    const SizedBox(height: AppSpacing.x6),
                    if (!_isOwner) ...[
                      AppBanner(context.l10n.authInviteCodeHint),
                      const SizedBox(height: AppSpacing.x4),
                      AppTextField(
                        label: context.l10n.authInviteCodeLabel,
                        controller: _inviteCodeCtr,
                        hintText: 'TF-XXXXX',
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        validator: (v) => InputValidators.emptyValidator(v, context),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                    ],
                    AppTextField(
                      label: context.l10n.authNameLabel,
                      controller: _nameCtr,
                      textInputAction: TextInputAction.next,
                      validator: (v) => InputValidators.emptyValidator(v, context),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    AppTextField(
                      label: context.l10n.authPhoneLabel,
                      controller: _phoneCtr,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      hintText: '+996 ___ __ __ __',
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '+996 ### ## ## ##',
                          filter: {'#': RegExp(r'\d')},
                        ),
                      ],
                      validator: (v) => InputValidators.phoneValidator(v, context, expectedLength: 12),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    AppTextField(
                      label: context.l10n.authEmailLabel,
                      controller: _emailCtr,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) => InputValidators.emailValidator(v, context),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    AppPasswordField(
                      label: context.l10n.authPassword,
                      controller: _passwordCtr,
                      textInputAction: TextInputAction.next,
                      validator: (v) => InputValidators.passwordValidator(v, context),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    AppPasswordField(
                      label: context.l10n.authConfirmPasswordLabel,
                      controller: _confirmCtr,
                      textInputAction: TextInputAction.next,
                      validator: (v) => InputValidators.passwordConfirmValidator(v, _passwordCtr.text, context),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    AppCheckboxField(
                      label: context.l10n.authAgreeTerms,
                      validator: (v) => (v ?? false) ? null : context.l10n.authAgreeTermsError,
                    ),
                    const SizedBox(height: AppSpacing.x6),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
              child: BlocConsumer<RegisterCubit, DataState<AuthResultModel>>(
                bloc: _registerCubit,
                listener: (context, state) {
                  if (state is DataSuccess<AuthResultModel>) {
                    context.read<AuthCubit>().setAuthenticated(state.data.user);
                  } else if (state is DataFailure<AuthResultModel>) {
                    context.handleError(state.exception);
                  }
                },
                builder: (context, state) {
                  return AppSubmitButton(
                    label: context.l10n.authCreateAccount,
                    isLoading: state.isLoading,
                    onPressed: _register,
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

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    final param = _isOwner
        ? RegisterOwnerParam(
            name: _nameCtr.text.trim(),
            phone: _phoneCtr.text.trim(),
            email: _emailCtr.text.trim(),
            password: _passwordCtr.text,
          )
        : RegisterManagerParam(
            name: _nameCtr.text.trim(),
            phone: _phoneCtr.text.trim(),
            email: _emailCtr.text.trim(),
            password: _passwordCtr.text,
            inviteCode: _inviteCodeCtr.text.trim(),
          );

    _registerCubit.register(param);
  }

  @override
  void dispose() {
    _registerCubit.close();
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    _passwordCtr.dispose();
    _confirmCtr.dispose();
    _inviteCodeCtr.dispose();
    super.dispose();
  }
}
