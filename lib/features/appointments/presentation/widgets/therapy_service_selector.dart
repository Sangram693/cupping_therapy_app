import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

enum AppointmentService { cuppingTherapy, consultation }

class TherapyServiceSelector extends StatelessWidget {
  const TherapyServiceSelector({
    super.key,
    required this.selectedService,
    required this.onSelected,
  });

  final AppointmentService? selectedService;
  final ValueChanged<AppointmentService> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final options = [
      (
        service: AppointmentService.cuppingTherapy,
        title: l10n.therapyServiceTitle,
        description: l10n.serviceDetailsUnavailable,
        icon: Icons.spa_outlined,
      ),
      (
        service: AppointmentService.consultation,
        title: l10n.consultation,
        description: l10n.consultationDetails,
        icon: Icons.chat_bubble_outline,
      ),
    ];

    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacing8),
            child: Semantics(
              button: true,
              selected: selectedService == option.service,
              label: '${option.title}. ${option.description}',
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onSelected(option.service),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    child: Row(
                      children: [
                        Icon(option.icon, color: colorScheme.primary),
                        const SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: AppDimensions.spacing4),
                              Text(
                                option.description,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        Icon(
                          selectedService == option.service
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: selectedService == option.service
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            child: Text(
              l10n.serviceOptionsNote,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ],
    );
  }
}
