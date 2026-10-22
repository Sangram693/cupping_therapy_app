import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'home_image_assets.dart';

class HomeImageCarousel extends StatefulWidget {
  const HomeImageCarousel({super.key});

  @override
  State<HomeImageCarousel> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends State<HomeImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isOpeningViewer = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    if (_currentPage != page) {
      setState(() => _currentPage = page);
    }
  }

  void _syncPageWithViewer(int page) {
    if (!mounted || page < 0 || page >= HomeImageAssets.paths.length) {
      return;
    }
    _pageController.jumpToPage(page);
    _handlePageChanged(page);
  }

  Future<void> _openViewer(int index) async {
    if (_isOpeningViewer) {
      return;
    }
    _isOpeningViewer = true;
    try {
      await context.pushNamed<void>(
        RouteNames.homeImageViewer,
        pathParameters: {'index': '$index'},
        extra: _syncPageWithViewer,
      );
    } finally {
      _isOpeningViewer = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight = (constraints.maxWidth * 0.54)
                .clamp(
                  AppDimensions.imageMedium * 2,
                  AppDimensions.imageMedium * 3,
                )
                .toDouble();

            return SizedBox(
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: HomeImageAssets.paths.length,
                  onPageChanged: _handlePageChanged,
                  itemBuilder: (context, index) {
                    final imageLabel = l10n.homeCarouselImageLabel(index + 1);
                    return Semantics(
                      button: true,
                      label: l10n.homeCarouselOpenImage(index + 1),
                      child: InkWell(
                        key: ValueKey(HomeImageAssets.heroTag(index)),
                        onTap: () => _openViewer(index),
                        child: Hero(
                          tag: HomeImageAssets.heroTag(index),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: colorScheme.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: Image.asset(
                              HomeImageAssets.paths[index],
                              fit: BoxFit.contain,
                              semanticLabel: imageLabel,
                              errorBuilder: (context, error, stackTrace) =>
                                  Semantics(
                                    label: imageLabel,
                                    child: ColoredBox(
                                      color: colorScheme.surfaceContainerHighest,
                                      child: Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          size: AppDimensions.iconXLarge,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (
              var index = 0;
              index < HomeImageAssets.paths.length;
              index++
            ) ...[
              if (index > 0) const SizedBox(width: AppDimensions.spacing4),
              ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: index == _currentPage
                      ? AppDimensions.spacing16
                      : AppDimensions.spacing8,
                  height: AppDimensions.spacing8,
                  decoration: BoxDecoration(
                    color: index == _currentPage
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCircular,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: AppDimensions.spacing12),
            Semantics(
              label: l10n.homeCarouselPageCounter(
                _currentPage + 1,
                HomeImageAssets.paths.length,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  '${_currentPage + 1} / ${HomeImageAssets.paths.length}',
                  key: ValueKey(_currentPage),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
