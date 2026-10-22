import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier({Box<String>? preferencesBox})
    : _preferencesBox = preferencesBox,
      super(_readSavedLocale(preferencesBox));

  static const String _localeKey = 'locale';
  static const Set<String> _supportedLanguageCodes = {'en', 'bn'};

  final Box<String>? _preferencesBox;

  static Locale _readSavedLocale(Box<String>? preferencesBox) {
    final savedLanguageCode = preferencesBox?.get(_localeKey) ?? 'en';
    if (!_supportedLanguageCodes.contains(savedLanguageCode)) {
      return const Locale('en');
    }
    return Locale(savedLanguageCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) {
      throw ArgumentError.value(locale, 'locale', 'Unsupported locale.');
    }

    final previousLocale = state;
    final nextLocale = Locale(locale.languageCode);
    state = nextLocale;
    try {
      await _preferencesBox?.put(_localeKey, locale.languageCode);
    } catch (_) {
      state = previousLocale;
      rethrow;
    }
  }
}
