import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _showBackendNotice(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.registrationUnavailable),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AppBackButton(fallbackRouteName: RouteNames.login),
                  ),
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/app_logo.jpg',
                          fit: BoxFit.cover,
                          semanticLabel: l10n.logoLabel(l10n.appName),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.createYourAccount,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.registrationTagline,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthForm(
                    submitLabel: l10n.createAccount,
                    onSubmit: () => _showBackendNotice(context),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        l10n.alreadyHaveAccount,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed(RouteNames.login);
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: Text(
                          l10n.signIn,
                          style: TextStyle(fontWeight: FontWeight.w700),
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
    );
  }
}
