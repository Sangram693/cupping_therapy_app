import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/locale_provider.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/theme_provider.dart';
import 'package:cupping_therapy/l10n/generated/app_localizations.dart';

class _AppointmentsTestApp extends ConsumerWidget {
  const _AppointmentsTestApp();

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
      home: const AppointmentsScreen(),
    );
  }
}

void main() {
  testWidgets('appointments screen updates for locale and theme changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(localeProvider.notifier).state = const Locale('en');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _AppointmentsTestApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Book your appointment'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Ayesha');
    container.read(localeProvider.notifier).state = const Locale('bn');
    await tester.pumpAndSettle();

    expect(find.text('আপনার অ্যাপয়েন্টমেন্টের অনুরোধ জানান'), findsOneWidget);
    expect(find.text('Ayesha'), findsNWidgets(2));

    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );

    container.read(localeProvider.notifier).state = const Locale('en');
    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
    await tester.pumpAndSettle();
    expect(find.text('Book your appointment'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );

    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
  });

  testWidgets('request action stays disabled until required data is complete', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProviderScope(child: _AppointmentsTestApp()));
    await tester.pumpAndSettle();

    final requestButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Request appointment'),
    );
    expect(requestButton.onPressed, isNull);
  });
}
