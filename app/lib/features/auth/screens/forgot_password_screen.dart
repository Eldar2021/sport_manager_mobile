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
  late final ForgotPasswordCubit _forgotPasswordCubit;

  @override
  void initState() {
    super.initState();
    _forgotPasswordCubit = ForgotPasswordCubit(GetIt.I<AuthRepository>());
  }

  @override
  void dispose() {
    _forgotPasswordCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      bloc: _forgotPasswordCubit,
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        final status = state.status;
        if (status.isSuccess) {
          context.pop();
        } else if (status.isFailure) {
          final exception = (status as DataFailure).exception;
          context.handleError(exception);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          leading: const BackBtn(),
          title: Text(l10n.authForgotPasswordTitle),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoBanner(text: l10n.authForgotPasswordBanner),
                      const SizedBox(height: AppSpacing.x6),
                      AuthTextField(
                        label: l10n.authEmailLabel,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        hintText: l10n.authForgotPasswordLoginEmailPlaceholder,
                        onChanged: _forgotPasswordCubit.emailChanged,
                        onSubmitted: state.canSubmit ? _forgotPasswordCubit.send : null,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x6,
                ),
                child: AuthSubmitButton(
                  label: l10n.authForgotPasswordSendLink,
                  isLoading: state.isLoading,
                  onPressed: state.canSubmit ? _forgotPasswordCubit.send : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.brandAmberLight,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.brandAmber),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.brandAmberDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
