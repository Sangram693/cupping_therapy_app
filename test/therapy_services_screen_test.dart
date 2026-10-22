import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cupping_therapy/app/router/route_names.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/core/network/paginated_result.dart';
import 'package:cupping_therapy/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/locale_provider.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/theme_provider.dart';
import 'package:cupping_therapy/features/therapy/presentation/screens/therapy_services_screen.dart';
import 'package:cupping_therapy/features/therapy/domain/entities/therapy_service_entity.dart';
import 'package:cupping_therapy/features/therapy/presentation/providers/therapy_provider.dart';
import 'package:cupping_therapy/l10n/generated/app_localizations.dart';

class _TherapyServicesTestApp extends ConsumerStatefulWidget {
  const _TherapyServicesTestApp();

  @override
  ConsumerState<_TherapyServicesTestApp> createState() =>
      _TherapyServicesTestAppState();
}

class _TherapyServicesTestAppState
    extends ConsumerState<_TherapyServicesTestApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/${RouteNames.therapy}',
    routes: [
      GoRoute(
        path: '/${RouteNames.therapy}',
        name: RouteNames.therapy,
        builder: (context, state) => const TherapyServicesScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.appointments}',
        name: RouteNames.appointments,
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/${RouteNames.home}',
        name: RouteNames.home,
        builder: (context, state) => const Scaffold(body: Text('Home')),
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}

final _servicePage = PaginatedResult<TherapyServiceEntity>(
  data: const [
    TherapyServiceEntity(
      id: 3,
      slug: 'cupping',
      nameEn: 'Cupping Therapy',
      nameBn: 'কাপিং থেরাপি',
      descriptionEn: 'This is introductory information only. Details and availability have not been confirmed.',
      descriptionBn: 'সেবার বিস্তারিত ও সময় API থেকে নিশ্চিত হবে।',
    ),
  ],
  currentPage: 1,
  lastPage: 1,
  perPage: 15,
  total: 1,
);

void main() {
  testWidgets('service details navigate to booking and return to therapy', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          therapyServicesProvider.overrideWith(
            (ref, page) async => _servicePage,
          ),
        ],
        child: const _TherapyServicesTestApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Therapy Services'), findsOneWidget);
    expect(find.text('Cupping Therapy'), findsOneWidget);
    expect(find.text('Cupping Therapy'), findsOneWidget);

    await tester.tap(find.text('View details').first);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'This is introductory information only. Details and availability have not been confirmed.',
      ),
      findsNWidgets(2),
    );

    await tester.tap(find.text('Book an Appointment').last);
    await tester.pumpAndSettle();
    expect(find.text('Appointments'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Therapy Services'), findsOneWidget);
  });

  testWidgets('service screen updates with locale and theme changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        therapyServicesProvider.overrideWith((ref, page) async => _servicePage),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _TherapyServicesTestApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Care, with your comfort in mind'), findsOneWidget);

    container.read(localeProvider.notifier).state = const Locale('bn');
    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(find.text('থেরাপি সেবাসমূহ'), findsOneWidget);
    expect(
      find.text(
        'সেবার তথ্য এখনো প্রস্তুত করা হচ্ছে। এই প্রাথমিক বিবরণগুলো নিশ্চিত সেবার তালিকা নয়; বর্তমান সেবা ও বিস্তারিত জানতে আমাদের সঙ্গে যোগাযোগ করুন।',
      ),
      findsOneWidget,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );

    container.read(localeProvider.notifier).state = const Locale('en');
    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
    await tester.pumpAndSettle();
    expect(find.text('Therapy Services'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
  });
}
