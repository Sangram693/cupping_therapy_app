import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/training_intro_card.dart';
import '../widgets/training_program_empty_state.dart';

class TrainingProgramsScreen extends StatelessWidget {
  const TrainingProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              children: const [
                TrainingIntroCard(),
                SizedBox(height: AppDimensions.spacing24),
                TrainingProgramEmptyState(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
