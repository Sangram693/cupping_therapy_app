import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

abstract interface class AuthStorage {
  Future<String?> readToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<bool> hasActiveSession();
}

class LocalAuthStorage implements AuthStorage {
  LocalAuthStorage({
    required this.sessionBox,
    this.secureStorage = const FlutterSecureStorage(),
  });

  static const String sessionBoxName = 'auth';
  static const String _tokenKey = 'auth_token';

  final Box<bool> sessionBox;
  final FlutterSecureStorage secureStorage;

  @override
  Future<bool> hasActiveSession() async =>
      (await readToken())?.isNotEmpty ?? false;

  @override
  Future<String?> readToken() => secureStorage.read(key: _tokenKey);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: _tokenKey, value: token);
    await sessionBox.put('isLoggedIn', true);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(key: _tokenKey);
    await sessionBox.put('isLoggedIn', false);
  }
}
