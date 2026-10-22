import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

class TrainingProgramEmptyState extends StatelessWidget {
  const TrainingProgramEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing24),
        child: Column(
          children: [
            Container(
              width: AppDimensions.imageSmall,
              height: AppDimensions.imageSmall,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                color: colorScheme.onPrimaryContainer,
                size: AppDimensions.iconMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              l10n.trainingProgramsEmptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              l10n.trainingProgramsEmptyDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              l10n.trainingEducationDisclaimer,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
