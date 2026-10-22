import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/logger.dart';
import '../router/app_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) => AppRouter().router);

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => const NotificationService(),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(baseUrl: AppConstants.apiBaseUrl),
);
