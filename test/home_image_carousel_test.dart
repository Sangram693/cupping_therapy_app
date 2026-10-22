import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:cupping_therapy/app/router/route_names.dart';
import 'package:cupping_therapy/app/theme/app_theme.dart';
import 'package:cupping_therapy/features/home/presentation/screens/home_image_viewer_screen.dart';
import 'package:cupping_therapy/features/home/presentation/widgets/home_image_carousel.dart';
import 'package:cupping_therapy/features/home/domain/entities/home_gallery_image_entity.dart';
import 'package:cupping_therapy/features/home/presentation/providers/home_provider.dart';
import 'package:cupping_therapy/l10n/generated/app_localizations.dart';

class _CarouselTestApp extends StatefulWidget {
  const _CarouselTestApp();

  @override
  State<_CarouselTestApp> createState() => _CarouselTestAppState();
}

class _CarouselTestAppState extends State<_CarouselTestApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/${RouteNames.home}',
    routes: [
      GoRoute(
        path: '/${RouteNames.home}',
        name: RouteNames.home,
        builder: (context, state) => const Scaffold(body: HomeImageCarousel()),
      ),
      GoRoute(
        path: '/${RouteNames.home}/image/:mediaId',
        name: RouteNames.homeImageViewer,
        builder: (context, state) => HomeImageViewerScreen(
          initialMediaId: state.pathParameters['mediaId']!,
          onPageChanged: state.extra is ValueChanged<int>
              ? state.extra as ValueChanged<int>
              : null,
        ),
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
      theme: AppTheme.light,
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

void main() {
  testWidgets('opens viewer, swipes images, and returns to carousel page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeGalleryProvider.overrideWith(
            (ref) async => List.generate(
              10,
              (index) => HomeGalleryImageEntity(
                id: '${index + 1}',
                mediaId: '${index + 1}',
                url: 'https://example.test/image-${index + 1}.jpg',
                sortOrder: index,
              ),
            ),
          ),
        ],
        child: const _CarouselTestApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('home-gallery-media-1')));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Close image viewer'), findsOneWidget);
    expect(find.text('1 / 10'), findsOneWidget);

    await tester.dragFrom(const Offset(320, 400), const Offset(-250, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 / 10'), findsOneWidget);

    await tester.tap(find.byTooltip('Close image viewer'));
    await tester.pumpAndSettle();
    expect(find.text('2 / 10'), findsOneWidget);
  });
}
