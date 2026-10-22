import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';
import '../../../../features/therapy/domain/entities/therapy_service_entity.dart';
import '../../../../features/therapy/presentation/providers/therapy_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/appointments_provider.dart';
import '../widgets/appointment_intro_card.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();
  TherapyServiceEntity? _selectedService;
  DateTime? _selectedDateTime;
  Map<String, List<String>> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    final selectedId = ref.read(selectedTherapyProvider);
    final services = ref.read(therapyServicesProvider(1)).valueOrNull?.data;
    if (selectedId.isNotEmpty && services != null) {
      for (final service in services) {
        if ('${service.id}' == selectedId) _selectedService = service;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _chooseDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateUtils.dateOnly(now),
      lastDate: DateTime(2100, 12, 31),
      helpText: AppLocalizations.of(context)!.preferredDate,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
      helpText: AppLocalizations.of(context)!.preferredTime,
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true ||
        _selectedService == null ||
        _selectedDateTime == null) {
      return;
    }
    setState(() => _serverErrors = {});
    try {
      final response = await ref
          .read(appointmentSubmissionProvider.notifier)
          .submit(
            serviceId: _selectedService!.id,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            dateTime: _selectedDateTime!,
            note: _noteController.text.trim(),
          );
      if (!mounted) return;
      final data = response;
      final reference = data['booking_reference']?.toString();
      final status = data['status']?.toString();
      final message = reference != null && status != null
          ? AppLocalizations.of(context)!
                .appointmentSubmitted(reference, status)
          : AppLocalizations.of(context)!.appointmentRequestSent;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      _formKey.currentState?.reset();
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _noteController.clear();
      setState(() {
        _selectedDateTime = null;
        _selectedService = null;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _serverErrors = error.validationErrors);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final services = ref.watch(therapyServicesProvider(1));
    final submission = ref.watch(appointmentSubmissionProvider);
    final signedIn = ref.watch(authStateProvider).valueOrNull != null;

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
                Text(
                  l10n.serviceSelection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spacing8),
                services.when(
                  loading: () => const AppLoading(),
                  error: (error, _) => AppErrorView(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(therapyServicesProvider(1)),
                  ),
                  data: (page) {
                    final initialId = ref.read(selectedTherapyProvider);
                    final initial =
                        _selectedService ??
                        page.data
                            .where((s) => '${s.id}' == initialId)
                            .firstOrNull;
                    if (_selectedService == null && initial != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _selectedService = initial);
                      });
                    }
                    return DropdownButtonFormField<TherapyServiceEntity>(
                      initialValue: initial,
                      decoration: InputDecoration(
                        labelText: l10n.serviceSelection,
                      ),
                      items: page.data
                          .map(
                            (service) => DropdownMenuItem(
                              value: service,
                              child: Text(
                                service.nameFor(
                                  Localizations.localeOf(context).languageCode,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (service) =>
                          setState(() => _selectedService = service),
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.spacing16),
                OutlinedButton.icon(
                  onPressed: _chooseDateTime,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(
                    _selectedDateTime == null
                        ? l10n.selectPreferredDateTime
                        : '${MaterialLocalizations.of(context).formatFullDate(_selectedDateTime!)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(_selectedDateTime!))}',
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  l10n.dateAvailabilityNote,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                if (_fieldError('appointment_at') case final dateError?)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spacing4),
                    child: Text(
                      dateError,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spacing16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(labelText: l10n.fullName),
                        validator: (value) =>
                            _fieldError('customer_name') ??
                            (value == null || value.trim().isEmpty
                                ? l10n.fieldRequired(l10n.fullName)
                                : null),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                        ),
                        validator: (value) =>
                            _fieldError('customer_phone') ??
                            (value == null || value.trim().isEmpty
                                ? l10n.fieldRequired(l10n.phoneNumber)
                                : null),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.emailOptional,
                        ),
                        validator: (_) => _fieldError('customer_email'),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      TextFormField(
                        controller: _noteController,
                        maxLength: 1000,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l10n.customerSchedulingNote,
                          helperText: l10n.nonSensitiveSchedulingNote,
                        ),
                        validator: (_) => _fieldError('customer_note'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                FilledButton.icon(
                  onPressed:
                      submission.isLoading ||
                          _selectedService == null ||
                          _selectedDateTime == null
                      ? null
                      : _submit,
                  icon: submission.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(l10n.requestAppointment),
                ),
                if (signedIn) ...[
                  const SizedBox(height: AppDimensions.spacing32),
                  Text(
                    l10n.upcomingAppointments,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  const _MyAppointments(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _fieldError(String field) => _serverErrors[field]?.firstOrNull;
}

class _MyAppointments extends ConsumerWidget {
  const _MyAppointments();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(myAppointmentsProvider(1))
        .when(
          loading: () => const AppLoading(),
          error: (error, _) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(myAppointmentsProvider(1)),
          ),
          data: (page) {
            if (page.data.isEmpty) return Text(l10n.appointmentsEmptyState);
            return Column(
              children: [
                for (final appointment in page.data)
                  Card(
                    child: ListTile(
                      title: Text(appointment.serviceName ?? l10n.appointments),
                      subtitle: Text(
                        '${appointment.bookingReference ?? appointment.id} · ${appointment.status} · ${MaterialLocalizations.of(context).formatMediumDate(appointment.date.toLocal())}',
                      ),
                      trailing:
                          (appointment.status == 'pending' ||
                                  appointment.status == 'confirmed') &&
                              appointment.date.isAfter(DateTime.now())
                          ? IconButton(
                              tooltip: l10n.cancelAppointment,
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: () async {
                                try {
                                  await ref
                                      .read(appointmentsRepositoryProvider)
                                      .cancelAppointment(appointment.id);
                                  ref.invalidate(myAppointmentsProvider(1));
                                } catch (error) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  }
                                }
                              },
                            )
                          : null,
                    ),
                  ),
              ],
            );
          },
        );
  }
}
