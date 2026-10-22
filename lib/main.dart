import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/di/providers.dart';
import 'app/app.dart';
import 'core/services/auth_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  final sessionBox = await Hive.openBox<bool>(LocalAuthStorage.sessionBoxName);
  final authStorage = LocalAuthStorage(
    sessionBox: sessionBox,
    secureStorage: const FlutterSecureStorage(),
  );

  runApp(
    ProviderScope(
      overrides: [authStorageProvider.overrideWithValue(authStorage)],
      child: const App(),
    ),
  );
}
