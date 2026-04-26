import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final ForgotPasswordCubit _forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _forgotPasswordCubit = ForgotPasswordCubit(GetIt.I<AuthRepository>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(l10n.authForgotPasswordTitle),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.x6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppInfoBanner(l10n.authForgotPasswordBanner),
                    const SizedBox(height: AppSpacing.x6),
                    AuthTextField(
                      label: l10n.authEmailLabel,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      hintText: l10n.authForgotPasswordLoginEmailPlaceholder,
                      onSubmitted: _submit,
                      validator: (value) => InputValidators.emailValidator(value, context),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    ForgotPasswordContactCard(
                      title: l10n.authForgotPasswordNoLink,
                      subtitle: l10n.authForgotPasswordContactUs,
                      onTap: () => ContactSupportSheet.show(context),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
              child: BlocConsumer<ForgotPasswordCubit, DataState<void>>(
                bloc: _forgotPasswordCubit,
                listener: _forgotPasswordListener,
                builder: (context, state) {
                  return AuthSubmitButton(
                    label: l10n.authForgotPasswordSendLink,
                    isLoading: state.isLoading,
                    onPressed: _submit,
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _forgotPasswordCubit.send(_emailController.text.trim());
    }
  }

  void _forgotPasswordListener(BuildContext context, DataState<void> state) {
    if (state is DataSuccess<void>) {
      context.pop();
    } else if (state is DataFailure) {
      context.handleError(state.exception);
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _emailController.dispose();
    _forgotPasswordCubit.close();
    super.dispose();
  }
}
