import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeImageCarousel extends StatefulWidget {
  const HomeImageCarousel({super.key});

  static const List<String> _imagePaths = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
    'assets/images/image6.jpg',
    'assets/images/image7.jpg',
    'assets/images/image8.jpg',
    'assets/images/image9.jpg',
    'assets/images/image10.jpg',
  ];

  @override
  State<HomeImageCarousel> createState() => _HomeImageCarouselState();
}

class _HomeImageCarouselState extends State<HomeImageCarousel> {
  int _currentPage = 0;

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
                  itemCount: HomeImageCarousel._imagePaths.length,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  itemBuilder: (context, index) {
                    final imageLabel = l10n.homeCarouselImageLabel(index + 1);
                    return Image.asset(
                      HomeImageCarousel._imagePaths[index],
                      fit: BoxFit.cover,
                      semanticLabel: imageLabel,
                      errorBuilder: (context, error, stackTrace) => Semantics(
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
              index < HomeImageCarousel._imagePaths.length;
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
                HomeImageCarousel._imagePaths.length,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  '${_currentPage + 1} / ${HomeImageCarousel._imagePaths.length}',
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
