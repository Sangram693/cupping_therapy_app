import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_back_button.dart';

class TherapyServicesScreen extends StatelessWidget {
  const TherapyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(fallbackRouteName: RouteNames.home),
        title: const Text('Therapy Services'),
      ),
      body: const Center(child: Text('Therapy services placeholder')),
    );
  }
}
