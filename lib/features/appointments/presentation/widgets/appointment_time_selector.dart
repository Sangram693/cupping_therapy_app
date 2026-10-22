import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../l10n/generated/app_localizations.dart';

enum AppointmentTimePreference { morning, afternoon, evening }

class AppointmentTimeSelector extends StatelessWidget {
  const AppointmentTimeSelector({
    super.key,
    required this.selectedTime,
    required this.onSelected,
  });

  final AppointmentTimePreference? selectedTime;
  final ValueChanged<AppointmentTimePreference> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final options = [
      (value: AppointmentTimePreference.morning, label: l10n.morning),
      (value: AppointmentTimePreference.afternoon, label: l10n.afternoon),
      (value: AppointmentTimePreference.evening, label: l10n.evening),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.preferredTime,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          l10n.preferredTimeNote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        Wrap(
          spacing: AppDimensions.spacing8,
          runSpacing: AppDimensions.spacing8,
          children: [
            for (final option in options)
              Semantics(
                button: true,
                selected: selectedTime == option.value,
                label: option.label,
                child: ChoiceChip(
                  label: Text(option.label),
                  selected: selectedTime == option.value,
                  onSelected: (_) => onSelected(option.value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
