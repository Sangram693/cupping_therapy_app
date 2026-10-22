import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  ColorScheme get colorScheme => appTheme.colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);
}
