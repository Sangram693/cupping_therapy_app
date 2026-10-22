import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:cupping_therapy/app/app.dart';
import 'package:cupping_therapy/app/di/providers.dart';
import 'package:cupping_therapy/app/router/route_names.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/core/services/app_color_service.dart';
import 'package:cupping_therapy/core/services/auth_storage.dart';
import 'package:cupping_therapy/core/utils/date_time_utils.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/locale_provider.dart';
import 'package:cupping_therapy/features/settings/presentation/screens/settings_screen.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/theme_provider.dart';
import 'package:cupping_therapy/features/authentication/presentation/widgets/auth_form.dart';
import 'package:cupping_therapy/features/authentication/presentation/screens/login_screen.dart';
import 'package:cupping_therapy/features/authentication/domain/entities/user_entity.dart';
import 'package:cupping_therapy/features/authentication/domain/repositories/auth_repository.dart';
import 'package:cupping_therapy/features/home/presentation/screens/home_screen.dart';
import 'package:cupping_therapy/features/profile/presentation/screens/profile_screen.dart';
import 'package:cupping_therapy/l10n/generated/app_localizations.dart';

class FakeAuthStorage implements AuthStorage {
  FakeAuthStorage({this.isLoggedIn = false}) {
    if (isLoggedIn) token = 'test-token';
  }

  bool isLoggedIn;
  String? token;

  @override
  Future<bool> hasActiveSession() async => token != null;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> saveToken(String value) async {
    token = value;
    isLoggedIn = true;
  }

  @override
  Future<void> clearToken() async {
    token = null;
    isLoggedIn = false;
  }
}

class RetryAuthStorage extends FakeAuthStorage {
  RetryAuthStorage() : super(isLoggedIn: true);

  bool shouldFail = true;

  @override
  Future<bool> hasActiveSession() async {
    if (shouldFail) {
      shouldFail = false;
      throw StateError('Session lookup failed');
    }
    return super.hasActiveSession();
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.storage);

  final FakeAuthStorage storage;
  static const _user = UserEntity(
    id: '1',
    name: 'Test User',
    email: 'user@example.com',
  );

  @override
  Future<UserEntity> login({
    required String identifier,
    required String password,
  }) async {
    await storage.saveToken('test-token');
    return _user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String preferredLocale,
  }) async {
    await storage.saveToken('test-token');
    return _user;
  }

  @override
  Future<UserEntity?> restoreSession() async =>
      await storage.hasActiveSession() ? _user : null;

  @override
  Future<void> logout() => storage.clearToken();

  @override
  Future<UserEntity> getProfile() async => _user;

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> changes) async => _user;
}

class _SettingsTestApp extends ConsumerWidget {
  const _SettingsTestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      locale: ref.watch(localeProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SettingsScreen(),
    );
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
    expect(darkTheme.colorScheme.primary, AppColors.secondary);
    expect(darkTheme.scaffoldBackgroundColor, isNot(AppColors.background));
    expect(darkTheme.cardTheme.color, isNot(AppColors.surface));
  });

  test('Date formatting follows the selected locale', () async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('bn');
    final date = DateTime(2026, 10, 22);

    expect(
      DateTimeUtils.formatShortDate(date, locale: 'bn'),
      isNot(DateTimeUtils.formatShortDate(date, locale: 'en')),
    );
  });

  test('Locale preference persists between notifier instances', () async {
    final directory = await Directory.systemTemp.createTemp(
      'cupping-therapy-locale-',
    );
    Hive.init(directory.path);
    final preferences = await Hive.openBox<String>('locale_test');

    final localeNotifier = LocaleNotifier(preferencesBox: preferences);
    await localeNotifier.setLocale(const Locale('bn'));
    final restoredNotifier = LocaleNotifier(preferencesBox: preferences);

    expect(restoredNotifier.state, const Locale('bn'));

    await preferences.close();
    await Hive.deleteBoxFromDisk('locale_test');
    await directory.delete(recursive: true);
  });

  test('Theme preference persists between notifier instances', () async {
    final directory = await Directory.systemTemp.createTemp(
      'cupping-therapy-theme-',
    );
    Hive.init(directory.path);
    final preferences = await Hive.openBox<String>('theme_test');

    final themeNotifier = ThemeNotifier(preferencesBox: preferences);
    expect(themeNotifier.state, ThemeMode.system);
    await themeNotifier.setThemeMode(ThemeMode.dark);
    final restoredNotifier = ThemeNotifier(preferencesBox: preferences);

    expect(restoredNotifier.state, ThemeMode.dark);
    await restoredNotifier.setThemeMode(ThemeMode.light);
    expect(ThemeNotifier(preferencesBox: preferences).state, ThemeMode.light);

    await preferences.close();
    await Hive.deleteBoxFromDisk('theme_test');
    await directory.delete(recursive: true);
  });

  testWidgets('Settings switches theme and keeps language selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeProvider.overrideWith((ref) => LocaleNotifier()),
          themeProvider.overrideWith((ref) => ThemeNotifier()),
        ],
        child: const _SettingsTestApp(),
      ),
    );

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System default'), findsOneWidget);
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.text('বাংলা'));
    await tester.pumpAndSettle();
    expect(find.text('থিম ও প্রদর্শন'), findsOneWidget);
    expect(find.text('ডার্ক'), findsOneWidget);

    await tester.tap(find.text('লাইট'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    await tester.tap(find.text('সিস্টেমের ডিফল্ট'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );
  });

  testWidgets('Settings switches the app language immediately', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [localeProvider.overrideWith((ref) => LocaleNotifier())],
        child: const _SettingsTestApp(),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('বাংলা'));
    await tester.pumpAndSettle();

    expect(find.text('সেটিংস'), findsOneWidget);
    expect(find.text('আপনার পছন্দের ভাষা নির্বাচন করুন।'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Splash screen navigates to login after two seconds', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
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
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Cupping Therapy'), findsOneWidget);
  });

  testWidgets('Splash screen can retry after session restoration fails', (
    tester,
  ) async {
    final authStorage = RetryAuthStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text("We couldn't restore your session."), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Cupping Therapy'), findsOneWidget);
  });

  testWidgets('Successful login stores only the bearer token and opens home', (
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
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Cupping Therapy'), findsOneWidget);
    expect(await authStorage.hasActiveSession(), isTrue);
    expect(authStorage.token, 'test-token');
  });

  testWidgets('Guest profile offers login and register without fake details', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome, guest'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Log out'), findsNothing);
    expect(find.text('Account details are not available yet.'), findsNothing);
  });

  testWidgets('Logout requires confirmation and clears session', (
    tester,
  ) async {
    final authStorage = FakeAuthStorage(isLoggedIn: true);
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (context, state) =>
              const Scaffold(body: Text('Login destination')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStorageProvider.overrideWithValue(authStorage),
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(authStorage),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Log out'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Log out?'), findsOneWidget);
    expect(await authStorage.hasActiveSession(), isTrue);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await authStorage.hasActiveSession(), isTrue);

    await tester.scrollUntilVisible(
      find.text('Log out'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();

    expect(await authStorage.hasActiveSession(), isFalse);
    expect(find.text('Login destination'), findsOneWidget);
    expect(router.canPop(), isFalse);
  });

  testWidgets('Auth form validates required fields and terms acceptance', (
    tester,
  ) async {
    var submitted = false;
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: SingleChildScrollView(
            child: AuthForm(
              submitLabel: 'Create account',
              onSubmit:
                  ({
                    required String name,
                    String? email,
                    String? phone,
                    required String password,
                    required String passwordConfirmation,
                  }) async {
                    submitted = true;
                  },
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required.'), findsOneWidget);
    expect(
      find.text('Enter an email address or phone number.'),
      findsOneWidget,
    );
    expect(find.text('Password is required.'), findsOneWidget);
    expect(find.text('Please accept the terms to continue.'), findsOneWidget);
    expect(submitted, isFalse);
  });
}
