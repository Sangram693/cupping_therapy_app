import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../core/widgets/app_back_button.dart';
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
        _loadError = 'Unable to load account information: $error';
      });
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will need to sign in again to access your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
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
          ..showSnackBar(SnackBar(content: Text('Unable to log out: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: const Text('Profile & account'),
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
                _SectionLabel(title: 'Your account'),
                const SizedBox(height: AppDimensions.spacing8),
                if (_isSignedIn == true) ...[
                  AccountMenuTile(
                    icon: Icons.event_available_outlined,
                    title: 'My Appointments',
                    onTap: () => context.pushNamed(RouteNames.appointments),
                  ),
                  AccountMenuTile(
                    icon: Icons.menu_book_outlined,
                    title: 'My Training',
                    onTap: () => context.pushNamed(RouteNames.training),
                  ),
                ] else if (_isSignedIn == false) ...[
                  AccountMenuTile(
                    icon: Icons.login_rounded,
                    title: 'Login',
                    subtitle: 'Sign in to access your account.',
                    onTap: () => context.goNamed(RouteNames.login),
                  ),
                  AccountMenuTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Register',
                    subtitle: 'Create an account to get started.',
                    onTap: () => context.pushNamed(RouteNames.register),
                  ),
                ],
                AccountMenuTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => context.pushNamed(RouteNames.settings),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionLabel(title: 'Information'),
                const SizedBox(height: AppDimensions.spacing8),
                AccountMenuTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Help & Support',
                  subtitle: 'Contact details are not available yet.',
                  onTap: _showSupportNotice,
                ),
                AccountMenuTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About the App',
                  onTap: _showAboutDialog,
                ),
                if (_isSignedIn == true) ...[
                  const SizedBox(height: AppDimensions.spacing24),
                  _SectionLabel(title: 'Session'),
                  const SizedBox(height: AppDimensions.spacing8),
                  AccountMenuTile(
                    icon: Icons.logout_rounded,
                    title: _isLoggingOut ? 'Logging out…' : 'Log out',
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Support contact details have not been added yet. Please check back soon.',
          ),
        ),
      );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationIcon: const Icon(
        Icons.spa_outlined,
        color: AppColors.primary,
        size: AppDimensions.iconLarge,
      ),
      children: const [
        Text(
          'An app for exploring Hijama therapy services and training information.',
        ),
      ],
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
    final title = isLoading
        ? 'Loading account…'
        : isSignedIn
        ? 'Your profile'
        : 'Welcome, guest';
    final subtitle =
        loadError ??
        (isSignedIn
            ? email ?? 'Account details are not available yet.'
            : 'Sign in or create an account to get started.');

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
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: loadError == null
                          ? AppColors.textSecondary
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
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
