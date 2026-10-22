import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/di/providers.dart';
import 'app/app.dart';
import 'core/services/auth_storage.dart';
import 'features/settings/presentation/providers/locale_provider.dart';
import 'features/settings/presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  await initializeDateFormatting('en');
  await initializeDateFormatting('bn');

  await Hive.initFlutter();
  final sessionBox = await Hive.openBox<bool>(LocalAuthStorage.sessionBoxName);
  final preferencesBox = await Hive.openBox<String>('preferences');
  final authStorage = LocalAuthStorage(
    sessionBox: sessionBox,
    secureStorage: const FlutterSecureStorage(),
  );

  runApp(
    ProviderScope(
      overrides: [
        authStorageProvider.overrideWithValue(authStorage),
        localeProvider.overrideWith(
          (ref) => LocaleNotifier(preferencesBox: preferencesBox),
        ),
        themeProvider.overrideWith(
          (ref) => ThemeNotifier(preferencesBox: preferencesBox),
        ),
      ],
      child: const App(),
    ),
  );
}
