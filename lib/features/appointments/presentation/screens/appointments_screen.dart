import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/appointments_provider.dart';
import '../widgets/appointment_intro_card.dart';
import '../widgets/appointment_summary_card.dart';
import '../widgets/appointment_time_selector.dart';
import '../widgets/therapy_service_selector.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  AppointmentService? _selectedService;
  AppointmentTimePreference? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _hasRequiredSelections(DateTime? date) =>
      _selectedService != null &&
      date != null &&
      _selectedTime != null &&
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  Future<void> _selectDate(DateTime? selectedDate) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate != null && !selectedDate.isBefore(now)
          ? selectedDate
          : now,
      firstDate: now,
      lastDate: DateTime(2100, 12, 31),
      helpText: AppLocalizations.of(context)!.preferredDate,
    );

    if (date != null) {
      ref.read(selectedAppointmentDateProvider.notifier).state = date;
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.appointmentRequestUnavailable)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDate = ref.watch(selectedAppointmentDateProvider);
    final canRequest = _hasRequiredSelections(selectedDate);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.appointments),
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
                const AppointmentIntroCard(),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionHeading(title: l10n.serviceSelection),
                const SizedBox(height: AppDimensions.spacing12),
                TherapyServiceSelector(
                  selectedService: _selectedService,
                  onSelected: (service) {
                    setState(() => _selectedService = service);
                  },
                ),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionHeading(title: l10n.preferredDate),
                const SizedBox(height: AppDimensions.spacing12),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.cardPadding,
                      vertical: AppDimensions.spacing4,
                    ),
                    leading: Icon(
                      Icons.calendar_month_outlined,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      selectedDate == null
                          ? l10n.selectPreferredDate
                          : MaterialLocalizations.of(context)
                                .formatMediumDate(selectedDate),
                    ),
                    subtitle: Text(l10n.dateAvailabilityNote),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectDate(selectedDate),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                AppointmentTimeSelector(
                  selectedTime: _selectedTime,
                  onSelected: (time) {
                    setState(() => _selectedTime = time);
                  },
                ),
                const SizedBox(height: AppDimensions.spacing24),
                _SectionHeading(title: l10n.contactDetails),
                const SizedBox(height: AppDimensions.spacing12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired(l10n.fullName);
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                          hintText: l10n.phoneNumberHint,
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired(l10n.phoneNumber);
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing24),
                AppointmentSummaryCard(
                  service: _selectedService,
                  date: selectedDate == null
                      ? null
                      : MaterialLocalizations.of(context)
                            .formatMediumDate(selectedDate),
                  time: _selectedTime,
                  contactName: _nameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                SizedBox(
                  height: AppDimensions.buttonHeightLarge,
                  child: FilledButton.icon(
                    onPressed: canRequest ? _submit : null,
                    icon: const Icon(Icons.send_outlined),
                    label: Text(l10n.requestAppointment),
                  ),
                ),
                if (!canRequest) ...[
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    l10n.completeRequiredDetails,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.spacing32),
                _SectionHeading(title: l10n.upcomingAppointments),
                const SizedBox(height: AppDimensions.spacing12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.cardPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimensions.spacing12),
                        Expanded(
                          child: Text(
                            l10n.appointmentsEmptyState,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
