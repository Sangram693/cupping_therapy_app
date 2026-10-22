import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier({Box<String>? preferencesBox})
    : _preferencesBox = preferencesBox,
      super(_readSavedTheme(preferencesBox));

  static const String _themeKey = 'themeMode';
  static const Map<String, ThemeMode> _themeModes = {
    'system': ThemeMode.system,
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
  };

  final Box<String>? _preferencesBox;

  static ThemeMode _readSavedTheme(Box<String>? preferencesBox) =>
      _themeModes[preferencesBox?.get(_themeKey)] ?? ThemeMode.system;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final themeName = switch (themeMode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
    final previousTheme = state;
    state = themeMode;

    try {
      await _preferencesBox?.put(_themeKey, themeName);
    } catch (_) {
      state = previousTheme;
      rethrow;
    }
  }
}
