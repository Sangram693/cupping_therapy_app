import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/training_program_entity.dart';
import '../providers/training_provider.dart';
import '../widgets/training_intro_card.dart';

class TrainingProgramsScreen extends ConsumerStatefulWidget {
  const TrainingProgramsScreen({super.key});

  @override
  ConsumerState<TrainingProgramsScreen> createState() =>
      _TrainingProgramsScreenState();
}

class _TrainingProgramsScreenState
    extends ConsumerState<TrainingProgramsScreen> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final programs = ref.watch(trainingProgramsProvider(_page));

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.trainingPrograms),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: programs.when(
              loading: () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TrainingIntroCard(),
                  const SizedBox(height: 240, child: AppLoading()),
                ],
              ),
              error: (error, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TrainingIntroCard(),
                  SizedBox(
                    height: 320,
                    child: AppErrorView(
                      message: error.toString(),
                      onRetry: () =>
                          ref.invalidate(trainingProgramsProvider(_page)),
                    ),
                  ),
                ],
              ),
              data: (page) {
                if (page.data.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(AppDimensions.screenPadding),
                    children: [
                      const TrainingIntroCard(),
                      const SizedBox(height: AppDimensions.spacing24),
                      Center(child: Text(l10n.noProgramsAvailable)),
                      if (ref.watch(authStateProvider).valueOrNull != null) ...[
                        const SizedBox(height: AppDimensions.spacing24),
                        Text(
                          l10n.myTraining,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        const _MyEnrollments(),
                      ],
                    ],
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(AppDimensions.screenPadding),
                  children: [
                    const TrainingIntroCard(),
                    const SizedBox(height: AppDimensions.spacing24),
                    for (final program in page.data) ...[
                      _ProgramCard(
                        program: program,
                        onOpen: () => _showDetails(program),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                    ],
                    if (page.hasMore)
                      OutlinedButton(
                        onPressed: () => setState(() => _page++),
                        child: Text(l10n.loadMore),
                      ),
                    if (ref.watch(authStateProvider).valueOrNull != null) ...[
                      const SizedBox(height: AppDimensions.spacing24),
                      Text(
                        l10n.myTraining,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      const _MyEnrollments(),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDetails(TrainingProgramEntity program) async {
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
                program.titleFor(locale),
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              if (program.imageUrl case final url?) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Image.network(
                  url,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ],
              if (program.descriptionFor(locale) case final description?) ...[
                const SizedBox(height: AppDimensions.spacing16),
                Text(description),
              ],
              if (program.curriculum != null) ...[
                const SizedBox(height: AppDimensions.spacing12),
                Text(program.curriculum.toString()),
              ],
              const SizedBox(height: AppDimensions.spacing20),
              FilledButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _showEnrollmentForm(program);
                },
                child: Text(l10n.enroll),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEnrollmentForm(TrainingProgramEntity program) async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    var isSubmitting = false;
    String? errorMessage;

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              program.titleFor(Localizations.localeOf(context).languageCode),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(labelText: l10n.fullName),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.fieldRequired(l10n.fullName)
                          : null,
                    ),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: l10n.phoneNumber),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l10n.fieldRequired(l10n.phoneNumber)
                          : null,
                    ),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.emailOptional,
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() != true) return;
                        setDialogState(() {
                          isSubmitting = true;
                          errorMessage = null;
                        });
                        try {
                          final result = await ref
                              .read(trainingEnrollmentProvider.notifier)
                              .submit(
                                programId: program.id,
                                name: name.text.trim(),
                                phone: phone.text.trim(),
                                email: email.text.trim(),
                              );
                          if (!dialogContext.mounted) return;
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.enrollmentStatus(
                                  '${result['status'] ?? ''}',
                                ),
                              ),
                            ),
                          );
                        } catch (error) {
                          if (dialogContext.mounted) {
                            setDialogState(() {
                              isSubmitting = false;
                              errorMessage = error is AppException
                                  ? [
                                      error.message,
                                      ...error.validationErrors.values.expand(
                                        (messages) => messages,
                                      ),
                                    ].join('\n')
                                  : error.toString();
                            });
                          }
                        }
                      },
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.enroll),
              ),
            ],
          ),
        ),
      );
    } finally {
      name.dispose();
      phone.dispose();
      email.dispose();
    }
  }
}

class _MyEnrollments extends ConsumerWidget {
  const _MyEnrollments();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(myTrainingEnrollmentsProvider(1))
        .when(
          loading: () => const AppLoading(),
          error: (error, _) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(myTrainingEnrollmentsProvider(1)),
          ),
          data: (page) {
            if (page.data.isEmpty) return Text(l10n.trainingEnrollmentsEmpty);
            return Column(
              children: [
                for (final enrollment in page.data)
                  Card(
                    child: ListTile(
                      title: Text(
                        enrollment['training_program'] is Map
                            ? '${(enrollment['training_program'] as Map)['slug'] ?? ''}'
                            : l10n.trainingPrograms,
                      ),
                      subtitle: Text('${enrollment['status'] ?? ''}'),
                    ),
                  ),
              ],
            );
          },
        );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, required this.onOpen});

  final TrainingProgramEntity program;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final description = program.descriptionFor(locale);
    final duration = locale == 'bn'
        ? program.durationTextBn
        : program.durationTextEn;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (program.imageUrl case final url?)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  child: Image.network(
                    url,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              Text(
                program.titleFor(locale),
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (description != null) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Text(description),
              ],
              if (duration != null || program.price != null) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Wrap(
                  spacing: AppDimensions.spacing12,
                  children: [
                    if (duration != null) Text(duration),
                    if (program.price != null)
                      Text('${program.currency ?? ''} ${program.price}'),
                  ],
                ),
              ],
              if (program.deliveryMode?.isNotEmpty == true) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Text(program.deliveryMode!),
              ],
              if (program.curriculum != null) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Text(program.curriculum.toString()),
              ],
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: onOpen,
                  child: Text(
                    AppLocalizations.of(context)!.trainingProgramDetails,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
