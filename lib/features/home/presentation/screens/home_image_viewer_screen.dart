import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/home_image_assets.dart';

class HomeImageViewerScreen extends StatefulWidget {
  const HomeImageViewerScreen({
    required this.initialIndex,
    this.onPageChanged,
    super.key,
  });

  final int initialIndex;
  final ValueChanged<int>? onPageChanged;

  @override
  State<HomeImageViewerScreen> createState() => _HomeImageViewerScreenState();
}

class _HomeImageViewerScreenState extends State<HomeImageViewerScreen> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex
        .clamp(0, HomeImageAssets.paths.length - 1)
        .toInt();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    setState(() => _currentPage = page);
    widget.onPageChanged?.call(page);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: HomeImageAssets.paths.length,
            onPageChanged: _handlePageChanged,
            itemBuilder: (context, index) {
              final imageLabel = l10n.homeCarouselImageLabel(index + 1);
              return Hero(
                tag: HomeImageAssets.heroTag(index),
                child: Material(
                  color: Colors.black,
                  child: SizedBox.expand(
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Image.asset(
                          HomeImageAssets.paths[index],
                          fit: BoxFit.contain,
                          semanticLabel: imageLabel,
                          errorBuilder: (context, error, stackTrace) =>
                              Semantics(
                                label: imageLabel,
                                child: SizedBox.expand(
                                  child: ColoredBox(
                                    color: Colors.black,
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.white70,
                                        size: AppDimensions.iconXLarge,
                                      ),
                                    ),
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
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                child: IconButton.filledTonal(
                  onPressed: () => context.pop(),
                  tooltip: l10n.homeImageViewerClose,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Semantics(
                  liveRegion: true,
                  label: l10n.homeImageViewerPosition(
                    _currentPage + 1,
                    HomeImageAssets.paths.length,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusCircular,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing12,
                        vertical: AppDimensions.spacing8,
                      ),
                      child: Text(
                        '${_currentPage + 1} / ${HomeImageAssets.paths.length}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
