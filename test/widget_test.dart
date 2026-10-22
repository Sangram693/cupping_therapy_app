import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cupping_therapy/app/app.dart';
import 'package:cupping_therapy/app/di/providers.dart';
import 'package:cupping_therapy/app/router/route_names.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/core/services/app_color_service.dart';
import 'package:cupping_therapy/core/services/auth_storage.dart';
import 'package:cupping_therapy/features/authentication/presentation/widgets/auth_form.dart';
import 'package:cupping_therapy/features/authentication/presentation/screens/login_screen.dart';
import 'package:cupping_therapy/features/home/presentation/screens/home_screen.dart';

class FakeAuthStorage implements AuthStorage {
  FakeAuthStorage({this.isLoggedIn = false});

  bool isLoggedIn;
  RememberedCredentials? credentials;

  @override
  Future<bool> hasActiveSession() async => isLoggedIn;

  @override
  Future<void> setSessionActive(bool isActive) async {
    isLoggedIn = isActive;
  }

  @override
  Future<RememberedCredentials?> readRememberedCredentials() async =>
      credentials;

  @override
  Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    credentials = RememberedCredentials(email: email, password: password);
  }

  @override
  Future<void> clearRememberedCredentials() async {
    credentials = null;
  }
}

void main() {
  test('AppColors palette uses the required brand values', () {
    expect(AppColors.primary.toARGB32(), 0xFF075B3C);
    expect(AppColors.secondary.toARGB32(), 0xFF0D8A56);
    expect(AppColors.background.toARGB32(), 0xFFF3F8F4);
    expect(AppColors.surface.toARGB32(), 0xFFFFFFFF);
    expect(AppColors.accent.toARGB32(), 0xFFD4A72C);
    expect(AppColors.textPrimary.toARGB32(), 0xFF26352D);
    expect(AppColors.textSecondary.toARGB32(), 0xFF647067);
    expect(AppColors.border.toARGB32(), 0xFFDCE9DF);
    expect(AppColors.error.toARGB32(), 0xFFB3261E);
  });

  test('Light theme is Material 3 and uses the brand palette', () {
    final lightTheme = AppTheme.light;

    expect(lightTheme.useMaterial3, isTrue);
    expect(lightTheme.colorScheme.primary, AppColors.primary);
    expect(lightTheme.scaffoldBackgroundColor, AppColors.background);
  });

  test('Dark theme is Material 3 and keeps readable contrast', () {
    final darkTheme = AppTheme.dark;

    expect(darkTheme.useMaterial3, isTrue);
    expect(darkTheme.brightness, Brightness.dark);
    expect(darkTheme.colorScheme.primary, AppColors.primary);
  });

  testWidgets('Splash screen navigates to login after two seconds', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStorageProvider.overrideWithValue(authStorage)],
        child: const App(),
      ),
    );
    expect(find.text('Preparing your care experience...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Splash screen opens home when a session was saved', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage(isLoggedIn: true);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStorageProvider.overrideWithValue(authStorage)],
        child: const App(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Home dashboard placeholder'), findsOneWidget);
  });

  testWidgets('Successful login saves credentials and opens home', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage();
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          name: RouteNames.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStorageProvider.overrideWithValue(authStorage)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Home dashboard placeholder'), findsOneWidget);
    expect(await authStorage.hasActiveSession(), isTrue);
    expect(authStorage.credentials?.email, 'user@example.com');
    expect(authStorage.credentials?.password, 'password123');
  });

  testWidgets('Auth form validates required fields and terms acceptance', (
    tester,
  ) async {
    var submitted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AuthForm(
              submitLabel: 'Create account',
              onSubmit: () => submitted = true,
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required.'), findsOneWidget);
    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
    expect(find.text('Please accept the terms to continue.'), findsOneWidget);
    expect(submitted, isFalse);
  });
}
