import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AppointmentIntroCard extends StatelessWidget {
  const AppointmentIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final steps = [
      l10n.bookingStepService,
      l10n.bookingStepDateTime,
      l10n.bookingStepRequest,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appointmentIntroTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              l10n.appointmentIntroDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            for (var index = 0; index < steps.length; index++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == steps.length - 1
                      ? 0
                      : AppDimensions.spacing12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.iconLarge,
                      height: AppDimensions.iconLarge,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(child: Text(steps[index])),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
