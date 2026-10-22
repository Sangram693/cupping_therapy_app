import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/therapy_service_card.dart';

class TherapyServicesScreen extends StatelessWidget {
  const TherapyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final services = [
      (
        icon: Icons.spa_outlined,
        title: l10n.therapyServiceTitle,
        description: l10n.serviceDetailsUnavailable,
      ),
      (
        icon: Icons.chat_bubble_outline,
        title: l10n.consultation,
        description: l10n.consultationDetails,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.therapyServices),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              children: [
                _TherapyIntro(),
                const SizedBox(height: AppDimensions.spacing24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Text(
                            l10n.serviceCatalogPreviewNote,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                Text(
                  l10n.ourServices,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;
                    if (!isWide) {
                      return Column(
                        children: [
                          for (
                            var index = 0;
                            index < services.length;
                            index++
                          ) ...[
                            if (index > 0)
                              const SizedBox(height: AppDimensions.spacing12),
                            _serviceCard(context, services[index]),
                          ],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (
                          var index = 0;
                          index < services.length;
                          index++
                        ) ...[
                          if (index > 0)
                            const SizedBox(width: AppDimensions.spacing12),
                          Expanded(
                            child: _serviceCard(context, services[index]),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.spacing24),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(RouteNames.appointments),
                  icon: const Icon(Icons.event_available_outlined),
                  label: Text(l10n.bookAppointment),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(
    BuildContext context,
    ({IconData icon, String title, String description}) service,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return TherapyServiceCard(
      icon: service.icon,
      title: service.title,
      description: service.description,
      previewLabel: l10n.servicePreviewLabel,
      detailsLabel: l10n.viewServiceDetails,
      onDetails: () => _showServiceDetails(context, service),
    );
  }

  Future<void> _showServiceDetails(
    BuildContext context,
    ({IconData icon, String title, String description}) service,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            AppDimensions.spacing8,
            AppDimensions.screenPadding,
            AppDimensions.spacing24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    service.icon,
                    size: AppDimensions.iconLarge,
                    color: Theme.of(sheetContext).colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Text(
                      service.title,
                      style: Theme.of(sheetContext).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Text(service.description),
              const SizedBox(height: AppDimensions.spacing12),
              Text(
                l10n.serviceDetailsPreviewNote,
                style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                  color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.pushNamed(RouteNames.appointments);
                },
                icon: const Icon(Icons.event_available_outlined),
                label: Text(l10n.bookAppointment),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TherapyIntro extends StatelessWidget {
  const _TherapyIntro();

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
                Icons.spa_outlined,
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
                    l10n.therapyServicesIntroTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    l10n.therapyServicesIntroDescription,
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
              semanticLabel: l10n.wellnessIconLabel,
            ),
          ],
        ),
      ),
    );
  }
}
