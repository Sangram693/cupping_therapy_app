import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

abstract interface class AuthStorage {
  Future<bool> hasActiveSession();

  Future<void> setSessionActive(bool isActive);

  Future<RememberedCredentials?> readRememberedCredentials();

  Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  });

  Future<void> clearRememberedCredentials();
}

class RememberedCredentials {
  const RememberedCredentials({required this.email, required this.password});

  final String email;
  final String password;
}

class LocalAuthStorage implements AuthStorage {
  LocalAuthStorage({
    required this.sessionBox,
    this.secureStorage = const FlutterSecureStorage(),
  });

  static const String sessionBoxName = 'auth';
  static const String _sessionKey = 'isLoggedIn';
  static const String _emailKey = 'remembered_email';
  static const String _passwordKey = 'remembered_password';

  final Box<bool> sessionBox;
  final FlutterSecureStorage secureStorage;

  @override
  Future<bool> hasActiveSession() async =>
      sessionBox.get(_sessionKey, defaultValue: false) ?? false;

  @override
  Future<void> setSessionActive(bool isActive) =>
      sessionBox.put(_sessionKey, isActive);

  @override
  Future<RememberedCredentials?> readRememberedCredentials() async {
    final email = await secureStorage.read(key: _emailKey);
    final password = await secureStorage.read(key: _passwordKey);
    if (email == null || password == null) {
      return null;
    }

    return RememberedCredentials(email: email, password: password);
  }

  @override
  Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    await secureStorage.write(key: _emailKey, value: email);
    await secureStorage.write(key: _passwordKey, value: password);
  }

  @override
  Future<void> clearRememberedCredentials() async {
    await secureStorage.delete(key: _emailKey);
    await secureStorage.delete(key: _passwordKey);
  }
}
