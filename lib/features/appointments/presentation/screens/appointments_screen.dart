import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../l10n/generated/app_localizations.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: Text(l10n.appointments),
      ),
      body: Center(child: Text(l10n.appointmentsPlaceholder)),
    );
  }
}
