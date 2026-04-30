import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _loginCtr;
  late final TextEditingController _newPasswordCtr;
  late final TextEditingController _confirmPasswordCtr;
  late final UpdatePasswordCubit _updatePasswordCubit;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    final repository = GetIt.I<AuthRepository>();
    final cachedUser = repository.getCachedUser();
    _loginCtr = TextEditingController(text: cachedUser?.email ?? '');
    _newPasswordCtr = TextEditingController();
    _confirmPasswordCtr = TextEditingController();
    _updatePasswordCubit = UpdatePasswordCubit(repository);
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(context.l10n.authUpdatePasswordTitle),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x4,
              AppSpacing.x4,
              kAppButtonFabClearance,
            ),
            children: [
              AppBanner(
                context.l10n.authUpdatePasswordHint,
                variant: AppBannerVariant.info,
                icon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: AppSpacing.x6),
              AppTextField(
                label: context.l10n.authUpdatePasswordLoginLabel,
                controller: _loginCtr,
                enabled: false,
              ),
              const SizedBox(height: AppSpacing.x4),
              AppPasswordField(
                label: context.l10n.authUpdatePasswordNewLabel,
                controller: _newPasswordCtr,
                textInputAction: TextInputAction.next,
                validator: (v) => InputValidators.passwordValidator(v, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              AppPasswordField(
                label: context.l10n.authUpdatePasswordRepeatLabel,
                controller: _confirmPasswordCtr,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) => InputValidators.passwordConfirmValidator(
                  v,
                  _newPasswordCtr.text,
                  context,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: BlocConsumer<UpdatePasswordCubit, DataState<void>>(
            bloc: _updatePasswordCubit,
            listener: _listener,
            builder: (context, state) {
              return AppButton(
                isLoading: state.isLoading,
                collapseOnScroll: true,
                onPressed: _submit,
                child: Text(context.l10n.authUpdatePasswordSubmit),
              );
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _updatePasswordCubit.updatePassword(
      login: _loginCtr.text.trim(),
      newPassword: _newPasswordCtr.text,
    );
  }

  void _listener(BuildContext context, DataState<void> state) {
    if (state is DataSuccess<void>) {
      context.pop();
    } else if (state is DataFailure<void>) {
      context.handleError(state.exception);
    }
  }

  @override
  void dispose() {
    _loginCtr.dispose();
    _newPasswordCtr.dispose();
    _confirmPasswordCtr.dispose();
    _updatePasswordCubit.close();
    super.dispose();
  }
}
