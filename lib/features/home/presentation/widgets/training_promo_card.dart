import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TrainingPromoCard extends StatelessWidget {
  const TrainingPromoCard({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimensions.avatarMedium,
                  height: AppDimensions.avatarMedium,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.primary,
                    size: AppDimensions.iconMedium,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.trainingPromoTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        l10n.trainingPromoDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                onPressed: onExplore,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: colorScheme.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                ),
                child: Text(l10n.exploreTraining),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
