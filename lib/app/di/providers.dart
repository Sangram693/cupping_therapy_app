import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_storage.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/logger.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/appointments/data/datasources/appointments_remote_data_source.dart';
import '../../features/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointments_repository.dart';
import '../../features/therapy/data/datasources/therapy_remote_data_source.dart';
import '../../features/therapy/data/repositories/therapy_repository_impl.dart';
import '../../features/therapy/domain/repositories/therapy_repository.dart';
import '../../features/training/data/datasources/training_remote_data_source.dart';
import '../../features/training/data/repositories/training_repository_impl.dart';
import '../../features/training/domain/repositories/training_repository.dart';
import '../../features/home/data/datasources/home_gallery_remote_data_source.dart';
import '../../features/home/data/repositories/home_gallery_repository_impl.dart';
import '../../features/home/data/datasources/contact_inquiry_remote_data_source.dart';
import '../../features/home/data/repositories/contact_inquiry_repository_impl.dart';
import '../router/app_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) => AppRouter().router);

final authStorageProvider = Provider<AuthStorage>(
  (ref) => throw StateError('AuthStorage must be initialized before the app.'),
);

final appLoggerProvider = Provider<AppLogger>((ref) => const AppLogger());

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => const NotificationService(),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: AppConstants.apiBaseUrl,
    tokenReader: () => ref.read(authStorageProvider).readToken(),
    onUnauthorized: () => ref.read(authStorageProvider).clearToken(),
  ),
);

final homeGalleryRemoteDataSourceProvider =
    Provider<HomeGalleryRemoteDataSource>(
      (ref) => HomeGalleryRemoteDataSource(ref.watch(apiClientProvider)),
    );

final homeGalleryRepositoryProvider = Provider<HomeGalleryRepositoryImpl>(
  (ref) =>
      HomeGalleryRepositoryImpl(ref.watch(homeGalleryRemoteDataSourceProvider)),
);

final contactInquiryRemoteDataSourceProvider =
    Provider<ContactInquiryRemoteDataSource>(
      (ref) => ContactInquiryRemoteDataSource(ref.watch(apiClientProvider)),
    );

final contactInquiryRepositoryProvider = Provider<ContactInquiryRepositoryImpl>(
  (ref) => ContactInquiryRepositoryImpl(
    ref.watch(contactInquiryRemoteDataSourceProvider),
  ),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authStorageProvider),
  ),
);

final therapyRemoteDataSourceProvider = Provider<TherapyRemoteDataSource>(
  (ref) => TherapyRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final therapyRepositoryProvider = Provider<TherapyRepository>(
  (ref) => TherapyRepositoryImpl(ref.watch(therapyRemoteDataSourceProvider)),
);

final appointmentsRemoteDataSourceProvider =
    Provider<AppointmentsRemoteDataSource>(
      (ref) => AppointmentsRemoteDataSourceImpl(ref.watch(apiClientProvider)),
    );

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>(
  (ref) => AppointmentsRepositoryImpl(
    ref.watch(appointmentsRemoteDataSourceProvider),
  ),
);

final trainingRemoteDataSourceProvider = Provider<TrainingRemoteDataSource>(
  (ref) => TrainingRemoteDataSourceImpl(ref.watch(apiClientProvider)),
);

final trainingRepositoryProvider = Provider<TrainingRepository>(
  (ref) => TrainingRepositoryImpl(ref.watch(trainingRemoteDataSourceProvider)),
);
