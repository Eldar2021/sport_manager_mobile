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

class RegisterOwnerScreen extends StatelessWidget {
  const RegisterOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(GetIt.I<AuthRepository>()),
      child: const _RegisterOwnerView(),
    );
  }
}

class _RegisterOwnerView extends StatefulWidget {
  const _RegisterOwnerView();

  @override
  State<_RegisterOwnerView> createState() => _RegisterOwnerViewState();
}

class _RegisterOwnerViewState extends State<_RegisterOwnerView> {
  final _nameCtr = TextEditingController();
  final _phoneCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _confirmCtr = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _agreed = false;
  String? _validationError;

  @override
  void dispose() {
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    _passwordCtr.dispose();
    _confirmCtr.dispose();
    super.dispose();
  }

  String? _validate(AppLocalizations l10n) {
    if (_nameCtr.text.trim().isEmpty ||
        _phoneCtr.text.trim().isEmpty ||
        _emailCtr.text.trim().isEmpty ||
        _passwordCtr.text.isEmpty) {
      return l10n.authFieldRequired;
    }
    if (_passwordCtr.text.length < 8) return l10n.authPasswordMinLength;
    if (_passwordCtr.text != _confirmCtr.text) return l10n.authPasswordsDoNotMatch;
    if (!_agreed) return l10n.authAgreeTerms;
    return null;
  }

  void _submit(AppLocalizations l10n) {
    final error = _validate(l10n);
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }
    setState(() => _validationError = null);
    context.read<RegisterCubit>().registerOwner(
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
    final textTheme = Theme.of(context).textTheme;

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
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.x4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                  child: Align(alignment: Alignment.centerLeft, child: BackBtn()),
                ),
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
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authPhoneLabel,
                          controller: _phoneCtr,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          hintText: '+996 ...',
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authEmailLabel,
                          controller: _emailCtr,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authPassword,
                          controller: _passwordCtr,
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.next,
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authConfirmPasswordLabel,
                          controller: _confirmCtr,
                          obscureText: !_showConfirm,
                          textInputAction: TextInputAction.done,
                          onSubmitted: () => _submit(l10n),
                          suffixIcon: IconButton(
                            icon: Icon(_showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _showConfirm = !_showConfirm),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        GestureDetector(
                          onTap: () => setState(() => _agreed = !_agreed),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: _agreed ? colorScheme.primary : Colors.transparent,
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  border: Border.all(
                                    color: _agreed ? colorScheme.primary : colorScheme.outline,
                                    width: 1.5,
                                  ),
                                ),
                                child: _agreed
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: colorScheme.surfaceContainer,
                                        size: 16,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: AppSpacing.x3),
                              Text(l10n.authAgreeTerms, style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        if (_validationError != null) ...[
                          const SizedBox(height: AppSpacing.x3),
                          Text(
                            _validationError!,
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.x6),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                  child: FilledButton(
                    onPressed: isLoading ? null : () => _submit(l10n),
                    child: isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.surfaceContainer,
                            ),
                          )
                        : Text(l10n.authCreateAccount),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
