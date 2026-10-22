import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSubmitting = false;
  String? _storageError;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    try {
      final credentials = await ref
          .read(authStorageProvider)
          .readRememberedCredentials();
      if (mounted && credentials != null) {
        setState(() {
          _emailController.text = credentials.email;
          _passwordController.text = credentials.password;
          _rememberMe = true;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _storageError = AppLocalizations.of(context)!.unableToLoadCredentials;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _storageError = null;
    });

    try {
      final authStorage = ref.read(authStorageProvider);
      if (_rememberMe) {
        await authStorage.saveRememberedCredentials(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await authStorage.clearRememberedCredentials();
      }
      await authStorage.setSessionActive(true);
      if (mounted) {
        context.goNamed(RouteNames.home);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _storageError = AppLocalizations.of(context)!.unableToSaveSignInState;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: AppDimensions.imageLarge,
                        height: AppDimensions.imageLarge,
                        // padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXLarge,
                          ),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: l10n.logoLabel(l10n.appName),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.signInTagline,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.emailAddress,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _emailController,
                      labelText: l10n.email,
                      hintText: l10n.emailHint,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validators.validateEmail(
                        value,
                        requiredMessage: l10n.emailRequired,
                        invalidMessage: l10n.invalidEmail,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.password,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _passwordController,
                      labelText: l10n.password,
                      hintText: l10n.passwordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      suffixIconTooltip: l10n.passwordVisibility,
                      onSuffixIconPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) => Validators.validatePassword(
                        value,
                        requiredMessage: l10n.passwordRequired,
                        minLengthMessage: l10n.passwordMinLength(8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.onSurfaceVariant),
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                          },
                        ),
                        Text(
                          l10n.rememberMe,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const Spacer(),
                      ],
                    ),
                    if (_storageError != null) ...[
                      Text(
                        _storageError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                l10n.signIn,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          l10n.noAccountPrompt,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(RouteNames.register),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: Text(
                            l10n.createAccount,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 16,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.wellbeingPriority,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
