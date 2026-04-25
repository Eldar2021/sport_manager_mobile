import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class RegisterOwnerScreen extends StatefulWidget {
  const RegisterOwnerScreen({super.key});

  @override
  State<RegisterOwnerScreen> createState() => _RegisterOwnerViewState();
}

class _RegisterOwnerViewState extends State<RegisterOwnerScreen> {
  late final RegisterCubit _registerCubit;
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _phoneCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '+996 ### ## ## ##',
    filter: {'#': RegExp(r'\d')},
  );
  final _passwordCtr = TextEditingController();
  final _confirmCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerCubit = RegisterCubit(GetIt.I<AuthRepository>());
  }

  @override
  void dispose() {
    _registerCubit.close();
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    _passwordCtr.dispose();
    _confirmCtr.dispose();
    super.dispose();
  }

  void _registerOwner() {
    if (!_formKey.currentState!.validate()) return;

    _registerCubit.registerOwner(
      RegisterOwnerBody(
        name: _nameCtr.text.trim(),
        phone: _phoneCtr.text.trim(),
        email: _emailCtr.text.trim(),
        password: _passwordCtr.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

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
                    title: l10n.authRegisterOwnerTitle,
                    badge: l10n.authOwnerBadge,
                    icon: Icons.business_center_rounded,
                    colorBadge: colorScheme.primary,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthTextField(
                            label: l10n.authNameLabel,
                            controller: _nameCtr,
                            textInputAction: TextInputAction.next,
                            validator: (v) => InputValidators.emptyValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthTextField(
                            label: l10n.authPhoneLabel,
                            controller: _phoneCtr,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            hintText: '+996 ___ __ __ __',
                            inputFormatters: [_phoneMask],
                            validator: (v) => InputValidators.phoneValidator(v, context, expectedLength: 12),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthTextField(
                            label: l10n.authEmailLabel,
                            controller: _emailCtr,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) => InputValidators.emailValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthPasswordField(
                            label: l10n.authPassword,
                            controller: _passwordCtr,
                            textInputAction: TextInputAction.next,
                            validator: (v) => InputValidators.passwordValidator(v, context),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AuthPasswordField(
                            label: l10n.authConfirmPasswordLabel,
                            controller: _confirmCtr,
                            textInputAction: TextInputAction.done,
                            onSubmitted: _registerOwner,
                            validator: (v) => InputValidators.passwordConfirmValidator(
                              v,
                              _passwordCtr.text,
                              context,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          AppCheckboxField(
                            label: l10n.authAgreeTerms,
                            validator: (v) => (v ?? false) ? null : l10n.authAgreeTermsError,
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
                      onPressed: _registerOwner,
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
