import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/user_entity.dart';

final rememberMeProvider = StateProvider<bool>((ref) => false);

final authStateProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>(
      (ref) => AuthController(ref),
    );

class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  AuthController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<UserEntity?> restoreSession() async {
    state = const AsyncLoading();
    try {
      final user = await _ref.read(authRepositoryProvider).restoreSession();
      state = AsyncData(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<UserEntity> login({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _ref
          .read(authRepositoryProvider)
          .login(identifier: identifier, password: password);
      state = AsyncData(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<UserEntity> register({
    required String name,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String preferredLocale,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await _ref
          .read(authRepositoryProvider)
          .register(
            name: name,
            email: email,
            phone: phone,
            password: password,
            passwordConfirmation: passwordConfirmation,
            preferredLocale: preferredLocale,
          );
      state = AsyncData(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _ref.read(authRepositoryProvider).logout();
    } finally {
      state = const AsyncData(null);
    }
  }

  Future<UserEntity> refreshProfile() async {
    try {
      final user = await _ref.read(authRepositoryProvider).getProfile();
      state = AsyncData(user);
      return user;
    } on AppException catch (error, stackTrace) {
      if (error.code == 401) {
        await _ref.read(authStorageProvider).clearToken();
        state = const AsyncData(null);
      } else {
        state = AsyncError(error, stackTrace);
      }
      rethrow;
    }
  }

  Future<UserEntity> updateProfile(Map<String, dynamic> changes) async {
    state = const AsyncLoading();
    try {
      final user = await _ref
          .read(authRepositoryProvider)
          .updateProfile(changes);
      state = AsyncData(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
