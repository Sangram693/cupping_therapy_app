import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: [
            Container(
              width: AppDimensions.avatarMedium,
              height: AppDimensions.avatarMedium,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconMedium,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Text(
                l10n.businessDetailsUnavailable,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing8),
            IconButton(
              onPressed: onContact,
              tooltip: l10n.contactUsForDetails,
              color: AppColors.primary,
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
