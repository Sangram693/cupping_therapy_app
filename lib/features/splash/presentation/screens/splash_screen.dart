import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';

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
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.surface],
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
                            // padding: const EdgeInsets.all(
                            //   AppDimensions.spacing8,
                            // ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXLarge,
                              ),
                              border: Border.all(color: AppColors.border),
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
                                semanticLabel: 'Hijama Care logo',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.spa_outlined,
                                        color: AppColors.primary,
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
                            'Hijama Care',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            'Your Wellness, Our Care',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppDimensions.spacing48),
                          if (_hasError)
                            _SessionError(onRetry: _checkSession)
                          else ...[
                            Semantics(
                              label: _isCheckingSession
                                  ? 'Restoring your session'
                                  : 'Preparing your care experience',
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
                              'Preparing your care experience...',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                          const SizedBox(height: AppDimensions.spacing64),
                          Text(
                            'THERAPY • TRAINING • WELLNESS',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
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
    return Column(
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          color: AppColors.error,
          size: AppDimensions.iconLarge,
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Text(
          "We couldn't restore your session.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(0, AppDimensions.buttonHeight),
          ),
        ),
      ],
    );
  }
}
