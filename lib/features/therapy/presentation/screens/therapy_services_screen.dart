import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/therapy_provider.dart';
import '../../domain/entities/therapy_service_entity.dart';

class TherapyServicesScreen extends ConsumerStatefulWidget {
  const TherapyServicesScreen({super.key});

  @override
  ConsumerState<TherapyServicesScreen> createState() =>
      _TherapyServicesScreenState();
}

class _TherapyServicesScreenState extends ConsumerState<TherapyServicesScreen> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = ref.watch(therapyServicesProvider(_page));

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
            child: result.when(
              loading: () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TherapyIntro(),
                  const SizedBox(height: 240, child: AppLoading()),
                ],
              ),
              error: (error, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TherapyIntro(),
                  SizedBox(
                    height: 320,
                    child: AppErrorView(
                      message: error.toString(),
                      onRetry: () =>
                          ref.invalidate(therapyServicesProvider(_page)),
                    ),
                  ),
                ],
              ),
              data: (page) {
                if (page.data.isEmpty) {
                  return Center(child: Text(l10n.noServicesAvailable));
                }
                return ListView(
                  padding: const EdgeInsets.all(AppDimensions.screenPadding),
                  children: [
                    _TherapyIntro(),
                    const SizedBox(height: AppDimensions.spacing24),
                    for (final service in page.data) ...[
                      _ServiceCard(
                        service: service,
                        onDetails: () => _showDetails(service),
                        onBook: () {
                          ref.read(selectedTherapyProvider.notifier).state =
                              '${service.id}';
                          context.pushNamed(RouteNames.appointments);
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                    ],
                    if (page.hasMore)
                      OutlinedButton(
                        onPressed: () => setState(() => _page++),
                        child: Text(l10n.loadMore),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDetails(TherapyServiceEntity service) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
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
              Text(
                service.nameFor(locale),
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              if (service.imageUrl case final url?) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Image.network(
                  url,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ],
              if (service.descriptionFor(locale) case final description?) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Text(description),
              ],
              const SizedBox(height: AppDimensions.spacing20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  ref.read(selectedTherapyProvider.notifier).state =
                      '${service.id}';
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.onDetails,
    required this.onBook,
  });

  final TherapyServiceEntity service;
  final VoidCallback onDetails;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service.imageUrl case final url?)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                child: Image.network(
                  url,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            Text(
              service.nameFor(locale),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (service.descriptionFor(locale) case final description?) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(description),
            ],
            if (service.price != null || service.durationMinutes != null) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Wrap(
                spacing: AppDimensions.spacing12,
                children: [
                  if (service.price != null)
                    Text('${service.currency ?? ''} ${service.price}'),
                  if (service.durationMinutes != null)
                    Text(l10n.durationMinutes(service.durationMinutes!)),
                ],
              ),
            ],
            const SizedBox(height: AppDimensions.spacing8),
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                TextButton(
                  onPressed: onDetails,
                  child: Text(l10n.viewServiceDetails),
                ),
                FilledButton.tonal(
                  onPressed: onBook,
                  child: Text(l10n.bookAppointment),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TherapyIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.therapyServicesIntroTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(l10n.serviceCatalogPreviewNote),
            ],
          ),
        ),
      ),
    );
  }
}
