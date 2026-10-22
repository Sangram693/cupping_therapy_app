import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeMessage(l10n.appName),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                l10n.welcomeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacing8),
        IconButton(
          onPressed: () => context.pushNamed(RouteNames.profile),
          tooltip: l10n.accountIconLabel,
          constraints: const BoxConstraints(
            minWidth: AppDimensions.buttonHeight,
            minHeight: AppDimensions.buttonHeight,
          ),
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.primary,
            backgroundColor: colorScheme.surface,
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          icon: const Icon(
            Icons.account_circle_outlined,
            size: AppDimensions.iconLarge,
          ),
        ),
      ],
    );
  }
}
