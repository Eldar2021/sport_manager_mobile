import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
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
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(context.l10n.authForgotPasswordTitle),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x6,
              AppSpacing.x6,
              AppSpacing.x6,
              kAppButtonFabClearance,
            ),
            children: [
              AppBanner(
                context.l10n.authForgotPasswordBanner,
                variant: AppBannerVariant.info,
                icon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: AppSpacing.x6),
              AppTextField(
                label: context.l10n.authEmailLabel,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                hintText: context.l10n.authForgotPasswordLoginEmailPlaceholder,
                onSubmitted: (_) => _submit(),
                validator: (value) => InputValidators.emailValidator(value, context),
              ),
              const SizedBox(height: AppSpacing.x4),
              ContactCard(
                title: context.l10n.authForgotPasswordNoLink,
                subtitle: context.l10n.authForgotPasswordContactUs,
                onTap: () => ContactSupportSheet.show(context),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: BlocConsumer<ForgotPasswordCubit, DataState<void>>(
            bloc: _forgotPasswordCubit,
            listener: _forgotPasswordListener,
            builder: (context, state) {
              return AppButton(
                isLoading: state.isLoading,
                collapseOnScroll: true,
                onPressed: _submit,
                child: Text(context.l10n.authForgotPasswordSendLink),
              );
            },
          ),
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
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
    _emailController.dispose();
    _forgotPasswordCubit.close();
    super.dispose();
  }
}
