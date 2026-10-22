import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isCheckingSession = false;
  bool _hasWaitedForMinimumDuration = false;
  bool _hasNavigated = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    if (_isCheckingSession || _hasNavigated) return;
    setState(() {
      _isCheckingSession = true;
      _hasError = false;
    });

    try {
      if (!_hasWaitedForMinimumDuration) {
        await Future<void>.delayed(const Duration(seconds: 2));
        _hasWaitedForMinimumDuration = true;
      }
      final isLoggedIn = await ref.read(authStorageProvider).hasActiveSession();
      if (mounted) {
        _hasNavigated = true;
        context.goNamed(isLoggedIn ? RouteNames.home : RouteNames.login);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    } finally {
      if (mounted && !_hasNavigated) {
        setState(() => _isCheckingSession = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            const _BackgroundDecoration(),
            SafeArea(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.formPaddingHorizontal,
                      vertical: AppDimensions.screenPaddingVertical,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight -
                            AppDimensions.screenPaddingVertical * 2,
                        maxWidth: AppDimensions.maxFormWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: AppDimensions.imageLarge,
                            height: AppDimensions.imageLarge,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXLarge,
                              ),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: AppDimensions.spacing24,
                                  offset: const Offset(
                                    0,
                                    AppDimensions.spacing8,
                                  ),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLarge,
                              ),
                              child: Image.asset(
                                'assets/images/app_logo.jpg',
                                fit: BoxFit.contain,
                                semanticLabel: l10n.logoLabel(l10n.appName),
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Icon(
                                        Icons.spa_outlined,
                                        color: colorScheme.primary,
                                        size: AppDimensions.iconXLarge,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing28),
                          const Icon(
                            Icons.eco_outlined,
                            color: AppColors.secondary,
                            size: AppDimensions.iconMedium,
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            l10n.appName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            l10n.appTagline,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: AppDimensions.spacing48),
                          if (_hasError)
                            _SessionError(onRetry: _checkSession)
                          else ...[
                            Semantics(
                              label: _isCheckingSession
                                  ? l10n.restoringSession
                                  : l10n.preparingExperience,
                              child: const SizedBox(
                                width: AppDimensions.iconMedium,
                                height: AppDimensions.iconMedium,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppDimensions.borderWidth + 1,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacing16),
                            Text(
                              l10n.preparingCare,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                          const SizedBox(height: AppDimensions.spacing64),
                          Text(
                            l10n.splashFooter,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -AppDimensions.spacing48,
            right: -AppDimensions.spacing48,
            child: _CircleDecoration(
              size: AppDimensions.imageLarge * 2,
              color: AppColors.secondary.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            bottom: AppDimensions.spacing64,
            left: -AppDimensions.spacing40,
            child: _CircleDecoration(
              size: AppDimensions.imageLarge * 1.5,
              color: AppColors.accent.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleDecoration extends StatelessWidget {
  const _CircleDecoration({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _SessionError extends StatelessWidget {
  const _SessionError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          Icons.cloud_off_outlined,
          color: colorScheme.error,
          size: AppDimensions.iconLarge,
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Text(
          AppLocalizations.of(context)!.sessionRestoreFailed,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: colorScheme.error, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(AppLocalizations.of(context)!.retry),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size(0, AppDimensions.buttonHeight),
          ),
        ),
      ],
    );
  }
}
