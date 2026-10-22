import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../features/home/domain/entities/home_gallery_image_entity.dart';
import '../providers/home_provider.dart';
import 'home_image_assets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeImageCarousel extends ConsumerStatefulWidget {
  const HomeImageCarousel({super.key});

  @override
  ConsumerState<HomeImageCarousel> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends ConsumerState<HomeImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isOpeningViewer = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    if (_currentPage != page) setState(() => _currentPage = page);
  }

  void _syncPageWithViewer(int page) {
    if (!mounted || !_pageController.hasClients || page < 0) return;
    _pageController.jumpToPage(page);
    _handlePageChanged(page);
  }

  Future<void> _openViewer(
    int index,
    List<HomeGalleryImageEntity> images,
  ) async {
    if (_isOpeningViewer || index >= images.length) return;
    _isOpeningViewer = true;
    try {
      await context.pushNamed<void>(
        RouteNames.homeImageViewer,
        pathParameters: {'mediaId': images[index].mediaId},
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
    return ref
        .watch(homeGalleryProvider)
        .when(
          loading: () => const SizedBox(height: 220, child: AppLoading()),
          error: (error, _) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(homeGalleryProvider),
          ),
          data: (images) {
            if (images.isEmpty) return const SizedBox.shrink();
            final currentPage = _currentPage.clamp(0, images.length - 1);
            if (currentPage != _currentPage) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _currentPage = currentPage);
              });
            }

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
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXLarge,
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: _handlePageChanged,
                          itemBuilder: (context, index) {
                            final image = images[index];
                            final fallback = l10n.homeCarouselImageLabel(
                              index + 1,
                            );
                            final label = image.altTextFor(
                              Localizations.localeOf(context).languageCode,
                              fallback,
                            );
                            final tag = HomeImageAssets.heroTag(image.mediaId);
                            return Semantics(
                              button: true,
                              label: l10n.homeCarouselOpenImage(index + 1),
                              child: InkWell(
                                key: ValueKey(tag),
                                onTap: () => _openViewer(index, images),
                                child: Hero(
                                  tag: tag,
                                  child: Container(
                                    width: double.infinity,
                                    color: colorScheme.surfaceContainerHighest,
                                    alignment: Alignment.center,
                                    child: image.url.isEmpty
                                        ? Semantics(
                                            label: label,
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                size: AppDimensions.iconXLarge,
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          )
                                        : Image.network(
                                            image.url,
                                            fit: BoxFit.contain,
                                            semanticLabel: label,
                                            errorBuilder: (_, _, _) => Semantics(
                                              label: label,
                                              child: Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  size:
                                                      AppDimensions.iconXLarge,
                                                  color: colorScheme
                                                      .onSurfaceVariant,
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
                    for (var index = 0; index < images.length; index++) ...[
                      if (index > 0)
                        const SizedBox(width: AppDimensions.spacing4),
                      ExcludeSemantics(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: index == currentPage
                              ? AppDimensions.spacing16
                              : AppDimensions.spacing8,
                          height: AppDimensions.spacing8,
                          decoration: BoxDecoration(
                            color: index == currentPage
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
                        currentPage + 1,
                        images.length,
                      ),
                      child: Text(
                        '${currentPage + 1} / ${images.length}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
  }
}
