import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
      body: Center(child: Text(l10n.trainingProgramsPlaceholder)),
    );
  }
}
