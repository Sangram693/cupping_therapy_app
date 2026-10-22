import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../constants/app_dimensions.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({required this.fallbackRouteName, super.key});

  final String fallbackRouteName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context)!.back,
      constraints: const BoxConstraints(
        minWidth: AppDimensions.buttonHeight,
        minHeight: AppDimensions.buttonHeight,
      ),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.goNamed(fallbackRouteName);
        }
      },
      icon: const Icon(Icons.arrow_back, size: AppDimensions.iconMedium),
    );
  }
}
