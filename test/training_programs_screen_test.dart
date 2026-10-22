import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cupping_therapy/app/router/route_names.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/core/network/paginated_result.dart';
import 'package:cupping_therapy/features/training/domain/entities/training_program_entity.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/locale_provider.dart';
import 'package:cupping_therapy/features/settings/presentation/providers/theme_provider.dart';
import 'package:cupping_therapy/features/training/presentation/providers/training_provider.dart';
import 'package:cupping_therapy/features/training/presentation/screens/training_programs_screen.dart';
import 'package:cupping_therapy/l10n/generated/app_localizations.dart';

class _TrainingTestApp extends ConsumerStatefulWidget {
  const _TrainingTestApp();

  @override
  ConsumerState<_TrainingTestApp> createState() => _TrainingTestAppState();
}

class _TrainingTestAppState extends ConsumerState<_TrainingTestApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/${RouteNames.home}',
    routes: [
      GoRoute(
        path: '/${RouteNames.home}',
        name: RouteNames.home,
        builder: (context, state) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => context.pushNamed(RouteNames.training),
              child: const Text('Open training'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/${RouteNames.training}',
        name: RouteNames.training,
        builder: (context, state) => const TrainingProgramsScreen(),
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

final _emptyTrainingPage = PaginatedResult<TrainingProgramEntity>(
  data: const [],
  currentPage: 1,
  lastPage: 1,
  perPage: 15,
  total: 0,
);

void main() {
  testWidgets('training catalogue shows honest empty state and pops back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trainingProgramsProvider.overrideWith(
            (ref, page) async => _emptyTrainingPage,
          ),
        ],
        child: const _TrainingTestApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open training'));
    await tester.pumpAndSettle();

    expect(find.text('Training Programs'), findsOneWidget);
    expect(find.text('Explore cupping therapy training'), findsOneWidget);
    expect(
      find.text('No training programs are currently available.'),
      findsOneWidget,
    );
    expect(find.text('Enroll now'), findsNothing);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Open training'), findsOneWidget);
  });

  testWidgets('training screen updates for Bengali and selected themes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        trainingProgramsProvider.overrideWith(
          (ref, page) async => _emptyTrainingPage,
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _TrainingTestApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open training'));
    await tester.pumpAndSettle();

    container.read(localeProvider.notifier).state = const Locale('bn');
    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
    await tester.pumpAndSettle();

    expect(find.text('প্রশিক্ষণ কর্মসূচি'), findsOneWidget);
    expect(find.text('কাপিং থেরাপি শেখার সুযোগ দেখুন'), findsOneWidget);
    expect(
      find.text('বর্তমানে কোনো প্রশিক্ষণ কর্মসূচি পাওয়া যাচ্ছে না।'),
      findsOneWidget,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
      Brightness.dark,
    );

    container.read(localeProvider.notifier).state = const Locale('en');
    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
    await tester.pumpAndSettle();
    expect(find.text('Training Programs'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
      Brightness.light,
    );

    await container.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
      Brightness.light,
    );
  });
}
