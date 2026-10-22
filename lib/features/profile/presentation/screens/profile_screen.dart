import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/account_menu_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool? _isSignedIn;
  String? _email;
  String? _loadError;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    try {
      final authStorage = ref.read(authStorageProvider);
      final isSignedIn = await authStorage.hasActiveSession();
      final credentials = isSignedIn
          ? await authStorage.readRememberedCredentials()
          : null;
      if (!mounted) return;

      setState(() {
        _isSignedIn = isSignedIn;
        _email = credentials?.email;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context)!.unableToLoadAccount;
      });
    }
  }

  Future<void> _confirmLogout() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutConfirmationTitle),
        content: Text(l10n.logoutConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (shouldLogOut != true || !mounted) return;

    setState(() => _isLoggingOut = true);
    try {
      await ref.read(authStorageProvider).setSessionActive(false);
      if (mounted) {
        context.goNamed(RouteNames.login);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoggingOut = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.unableToLogout),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.profileAndAccount),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxFormWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              children: [
                _ProfileSummary(
                  isLoading: _isSignedIn == null && _loadError == null,
                  isSignedIn: _isSignedIn ?? false,
                  email: _email,
                  loadError: _loadError,
                ),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionLabel(title: l10n.yourAccount),
                const SizedBox(height: AppDimensions.spacing8),
                if (_isSignedIn == true) ...[
                  AccountMenuTile(
                    icon: Icons.event_available_outlined,
                    title: l10n.myAppointments,
                    onTap: () => context.pushNamed(RouteNames.appointments),
                  ),
                  AccountMenuTile(
                    icon: Icons.menu_book_outlined,
                    title: l10n.myTraining,
                    onTap: () => context.pushNamed(RouteNames.training),
                  ),
                ] else if (_isSignedIn == false) ...[
                  AccountMenuTile(
                    icon: Icons.login_rounded,
                    title: l10n.login,
                    subtitle: l10n.signInToAccessAccount,
                    onTap: () => context.goNamed(RouteNames.login),
                  ),
                  AccountMenuTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: l10n.register,
                    subtitle: l10n.createAccountSubtitle,
                    onTap: () => context.pushNamed(RouteNames.register),
                  ),
                ],
                AccountMenuTile(
                  icon: Icons.settings_outlined,
                  title: l10n.settings,
                  onTap: () => context.pushNamed(RouteNames.settings),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionLabel(title: l10n.information),
                const SizedBox(height: AppDimensions.spacing8),
                AccountMenuTile(
                  icon: Icons.support_agent_outlined,
                  title: l10n.helpAndSupport,
                  subtitle: l10n.supportDetailsUnavailable,
                  onTap: _showSupportNotice,
                ),
                AccountMenuTile(
                  icon: Icons.info_outline_rounded,
                  title: l10n.aboutApp,
                  onTap: _showAboutDialog,
                ),
                if (_isSignedIn == true) ...[
                  const SizedBox(height: AppDimensions.spacing24),
                  _SectionLabel(title: l10n.session),
                  const SizedBox(height: AppDimensions.spacing8),
                  AccountMenuTile(
                    icon: Icons.logout_rounded,
                    title: _isLoggingOut ? l10n.loggingOut : l10n.logout,
                    onTap: _isLoggingOut ? null : _confirmLogout,
                    isDestructive: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSupportNotice() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.supportContactUnavailable)));
  }

  void _showAboutDialog() {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: l10n.appName,
      applicationIcon: const Icon(
        Icons.spa_outlined,
        color: AppColors.primary,
        size: AppDimensions.iconLarge,
      ),
      children: [Text(l10n.aboutDescription)],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({
    required this.isLoading,
    required this.isSignedIn,
    required this.email,
    required this.loadError,
  });

  final bool isLoading;
  final bool isSignedIn;
  final String? email;
  final String? loadError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final title = isLoading
        ? l10n.loadingAccount
        : isSignedIn
        ? l10n.yourProfile
        : l10n.welcomeGuest;
    final subtitle =
        loadError ??
        (isSignedIn
            ? email ?? l10n.accountDetailsUnavailable
            : l10n.signInOrCreateAccount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: [
            Container(
              width: AppDimensions.avatarLarge,
              height: AppDimensions.avatarLarge,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSignedIn
                    ? Icons.person_outline_rounded
                    : Icons.person_add_alt_1_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconLarge,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: loadError == null
                          ? colorScheme.onSurfaceVariant
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
