import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/home_image_assets.dart';

class HomeImageViewerScreen extends ConsumerStatefulWidget {
  const HomeImageViewerScreen({
    required this.initialMediaId,
    this.onPageChanged,
    super.key,
  });

  final String initialMediaId;
  final ValueChanged<int>? onPageChanged;

  @override
  ConsumerState<HomeImageViewerScreen> createState() =>
      _HomeImageViewerScreenState();
}

class _HomeImageViewerScreenState extends ConsumerState<HomeImageViewerScreen> {
  PageController? _pageController;
  int _currentPage = 0;
  String? _loadedMediaId;

  @override
  void dispose() {
    _pageController?.dispose();
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
      body: ref
          .watch(homeGalleryProvider)
          .when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (error, _) => AppErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(homeGalleryProvider),
            ),
            data: (images) {
              if (images.isEmpty) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: AppDimensions.iconXLarge,
                  ),
                );
              }
              final routeIndex = images.indexWhere(
                (image) => image.mediaId == widget.initialMediaId,
              );
              final initialIndex = routeIndex < 0 ? 0 : routeIndex;
              if (_loadedMediaId != widget.initialMediaId) {
                _pageController?.dispose();
                _currentPage = initialIndex;
                _pageController = PageController(initialPage: initialIndex);
                _loadedMediaId = widget.initialMediaId;
              }

              return Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: _handlePageChanged,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final fallback = l10n.homeCarouselImageLabel(index + 1);
                      final label = image.altTextFor(
                        Localizations.localeOf(context).languageCode,
                        fallback,
                      );
                      return Hero(
                        tag: HomeImageAssets.heroTag(image.mediaId),
                        child: Material(
                          color: Colors.black,
                          child: SizedBox.expand(
                            child: Center(
                              child: InteractiveViewer(
                                minScale: 1,
                                maxScale: 4,
                                child: image.url.isEmpty
                                    ? Semantics(
                                        label: label,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.white70,
                                            size: AppDimensions.iconXLarge,
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        image.url,
                                        fit: BoxFit.contain,
                                        semanticLabel: label,
                                        errorBuilder: (_, _, _) => Semantics(
                                          label: label,
                                          child: const Center(
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
                            images.length,
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
                                '${_currentPage + 1} / ${images.length}',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
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
              );
            },
          ),
    );
  }
}
