import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(GetIt.I<AuthRepository>()),
      child: const _ForgotPasswordBody(),
    );
  }
}

class _ForgotPasswordBody extends StatefulWidget {
  const _ForgotPasswordBody();

  @override
  State<_ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<_ForgotPasswordBody> {
  final _loginCtr = TextEditingController();
  final _isEnable = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _loginCtr.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final email = _loginCtr.text.trim();
    _isEnable.value = InputValidators.isValidEmail(email);
  }

  @override
  void dispose() {
    _loginCtr
      ..removeListener(_onTextChanged)
      ..dispose();
    _isEnable.dispose();
    super.dispose();
  }

  void _submit() => context.read<ForgotPasswordCubit>().send(_loginCtr.text.trim());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ForgotPasswordCubit, DataState<void>>(
      listener: (context, state) {
        if (state is DataSuccess<void>) {
          context.pop();
        } else if (state is DataFailure<void>) {
          context.handleError(state.exception);
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
                        controller: _loginCtr,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        hintText: l10n.authForgotPasswordLoginEmailPlaceholder,
                        onSubmitted: () {
                          if (_isEnable.value && !state.isLoading) _submit();
                        },
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isEnable,
                  builder: (_, enabled, _) => AuthSubmitButton(
                    label: l10n.authForgotPasswordSendLink,
                    isLoading: state.isLoading,
                    onPressed: enabled && !state.isLoading ? _submit : null,
                  ),
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
