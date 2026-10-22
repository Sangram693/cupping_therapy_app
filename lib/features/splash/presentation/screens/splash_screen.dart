import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    setState(() => _error = null);

    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      final isLoggedIn = await ref.read(authStorageProvider).hasActiveSession();
      if (mounted) {
        context.goNamed(isLoggedIn ? RouteNames.home : RouteNames.login);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'Unable to restore your session: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/app_logo.jpg',
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text('Cupping Therapy'),
            const SizedBox(height: 8),
            if (_error == null)
              const Text('Preparing your care experience...')
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _checkSession, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
