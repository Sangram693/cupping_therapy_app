import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/network/paginated_result.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../domain/entities/appointment_entity.dart';

final selectedAppointmentDateProvider = StateProvider<DateTime?>((ref) => null);

final myAppointmentsProvider =
    FutureProvider.family<PaginatedResult<AppointmentEntity>, int>(
      (ref, page) => ref
          .watch(appointmentsRepositoryProvider)
          .getMyAppointments(page: page),
    );

final appointmentSubmissionProvider =
    StateNotifierProvider<AppointmentSubmissionController, AsyncValue<void>>(
      (ref) => AppointmentSubmissionController(ref),
    );

class AppointmentSubmissionController extends StateNotifier<AsyncValue<void>> {
  AppointmentSubmissionController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<Map<String, dynamic>> submit({
    required int serviceId,
    required String name,
    required String phone,
    String? email,
    required DateTime dateTime,
    String? note,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await _ref
          .read(appointmentsRepositoryProvider)
          .createAppointment(
            serviceId: serviceId,
            customerName: name,
            customerPhone: phone,
            customerEmail: email,
            appointmentAt: dateTime,
            customerNote: note,
          );
      state = const AsyncData(null);
      if (_ref.read(authStateProvider).valueOrNull != null) {
        _ref.invalidate(myAppointmentsProvider);
      }
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
