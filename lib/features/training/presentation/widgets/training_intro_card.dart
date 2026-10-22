import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TrainingIntroCard extends StatelessWidget {
  const TrainingIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppDimensions.avatarLarge,
              height: AppDimensions.avatarLarge,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: colorScheme.primary,
                size: AppDimensions.iconLarge,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.trainingIntroTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    l10n.trainingIntroDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Icon(
              Icons.auto_awesome_outlined,
              color: AppColors.accent,
              size: AppDimensions.iconMedium,
              semanticLabel: l10n.trainingIconLabel,
            ),
          ],
        ),
      ),
    );
  }
}
