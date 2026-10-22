import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -AppDimensions.spacing24,
            right: -AppDimensions.spacing20,
            child: Container(
              width: AppDimensions.imageLarge,
              height: AppDimensions.imageLarge,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppDimensions.spacing4,
                    bottom: AppDimensions.spacing4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover ${AppConstants.appName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        'Explore our services and professional training programs.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.surface.withValues(alpha: 0.88),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: FilledButton(
                          onPressed: onExplore,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMedium,
                              ),
                            ),
                          ),
                          child: const Text('Explore Services'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              const Padding(
                padding: EdgeInsets.only(top: AppDimensions.spacing8),
                child: Icon(
                  Icons.spa_outlined,
                  color: AppColors.accent,
                  size: AppDimensions.iconXLarge,
                  semanticLabel: 'Wellness',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
