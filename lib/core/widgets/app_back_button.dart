import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_dimensions.dart';
import '../services/app_color_service.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({required this.fallbackRouteName, super.key});

  final String fallbackRouteName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      constraints: const BoxConstraints(
        minWidth: AppDimensions.buttonHeight,
        minHeight: AppDimensions.buttonHeight,
      ),
      color: AppColors.primary,
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
