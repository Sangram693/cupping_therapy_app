import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/services/app_color_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'appointment_time_selector.dart';
import 'therapy_service_selector.dart';

class AppointmentSummaryCard extends StatelessWidget {
  const AppointmentSummaryCard({
    super.key,
    required this.service,
    required this.date,
    required this.time,
    required this.contactName,
    required this.phoneNumber,
  });

  final AppointmentService? service;
  final String? date;
  final AppointmentTimePreference? time;
  final String contactName;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final serviceLabel = switch (service) {
      AppointmentService.cuppingTherapy => l10n.therapyServiceTitle,
      AppointmentService.consultation => l10n.consultation,
      null => l10n.notSelected,
    };
    final timeLabel = switch (time) {
      AppointmentTimePreference.morning => l10n.morning,
      AppointmentTimePreference.afternoon => l10n.afternoon,
      AppointmentTimePreference.evening => l10n.evening,
      null => l10n.notSelected,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingSummary,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            _SummaryRow(label: l10n.serviceSelection, value: serviceLabel),
            _SummaryRow(
              label: l10n.preferredDate,
              value: date ?? l10n.notSelected,
            ),
            _SummaryRow(label: l10n.preferredTime, value: timeLabel),
            _SummaryRow(
              label: l10n.fullName,
              value: contactName.isEmpty ? l10n.notSelected : contactName,
            ),
            _SummaryRow(
              label: l10n.phoneNumber,
              value: phoneNumber.isEmpty ? l10n.notSelected : phoneNumber,
              isLast: true,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              l10n.requestNotConfirmed,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        top: AppDimensions.spacing8,
        bottom: isLast ? 0 : AppDimensions.spacing4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
