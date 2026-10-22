import '../../../../core/network/paginated_result.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  const AppointmentsRepository();

  Future<Map<String, dynamic>> createAppointment({
    required int serviceId,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required DateTime appointmentAt,
    String? customerNote,
  });
  Future<PaginatedResult<AppointmentEntity>> getMyAppointments({int page = 1});
  Future<void> cancelAppointment(String id);
}
