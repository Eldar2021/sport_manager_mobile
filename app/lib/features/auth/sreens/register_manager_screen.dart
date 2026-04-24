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

class RegisterManagerScreen extends StatelessWidget {
  const RegisterManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(GetIt.I<AuthRepository>()),
      child: const _RegisterManagerView(),
    );
  }
}

class _RegisterManagerView extends StatefulWidget {
  const _RegisterManagerView();

  @override
  State<_RegisterManagerView> createState() => _RegisterManagerViewState();
}

class _RegisterManagerViewState extends State<_RegisterManagerView> {
  final _inviteCodeCtr = TextEditingController();
  final _usernameCtr = TextEditingController();
  final _nameCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _showPassword = false;
  String? _validationError;

  @override
  void dispose() {
    _inviteCodeCtr.dispose();
    _usernameCtr.dispose();
    _nameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  String? _validate(AppLocalizations l10n) {
    if (_inviteCodeCtr.text.trim().isEmpty ||
        _usernameCtr.text.trim().isEmpty ||
        _nameCtr.text.trim().isEmpty ||
        _passwordCtr.text.isEmpty) {
      return l10n.authFieldRequired;
    }
    if (_passwordCtr.text.length < 8) return l10n.authPasswordMinLength;
    return null;
  }

  void _submit(AppLocalizations l10n) {
    final error = _validate(l10n);
    if (error != null) {
      setState(() => _validationError = error);
      return;
    }
    setState(() => _validationError = null);
    context.read<RegisterCubit>().registerManager(
      RegisterManagerBody(
        inviteCode: _inviteCodeCtr.text.trim(),
        username: _usernameCtr.text.trim(),
        name: _nameCtr.text.trim(),
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
                  title: l10n.authRegisterManagerTitle,
                  badge: l10n.authManagerBadge,
                  icon: Icons.badge_outlined,
                  colorBadge: AppColors.successGreen,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.x4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: AppRadius.cardBorderRadius,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 18),
                              const SizedBox(width: AppSpacing.x2),
                              Expanded(
                                child: Text(
                                  l10n.authInviteCodeHint,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authInviteCodeLabel,
                          controller: _inviteCodeCtr,
                          hintText: 'TF-XXXXX',
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authUsernameLabel,
                          controller: _usernameCtr,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authNameLabel,
                          controller: _nameCtr,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        AuthTextField(
                          label: l10n.authPassword,
                          controller: _passwordCtr,
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: () => _submit(l10n),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
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
                  padding: const EdgeInsets.fromLTRB(AppSpacing.x6, AppSpacing.x2, AppSpacing.x6, AppSpacing.x6),
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
