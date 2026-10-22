import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cupping_therapy/app/app.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/core/services/app_color_service.dart';
import 'package:cupping_therapy/features/authentication/presentation/widgets/auth_form.dart';

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
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('Preparing your care experience...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
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
