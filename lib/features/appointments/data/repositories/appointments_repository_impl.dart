import '../../domain/repositories/appointments_repository.dart';
import '../../domain/entities/appointment_entity.dart';
import '../datasources/appointments_remote_data_source.dart';
import '../../../../core/network/paginated_result.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  const AppointmentsRepositoryImpl(this._remote);

  final AppointmentsRemoteDataSource _remote;

  @override
  Future<Map<String, dynamic>> createAppointment({
    required int serviceId,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    required DateTime appointmentAt,
    String? customerNote,
  }) => _remote.createAppointment({
    'therapy_service_id': serviceId,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    if (customerEmail != null && customerEmail.isNotEmpty)
      'customer_email': customerEmail,
    'appointment_at': _withLocalOffset(appointmentAt),
    if (customerNote != null && customerNote.isNotEmpty)
      'customer_note': customerNote,
  });

  String _withLocalOffset(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final offset = localDateTime.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${localDateTime.toIso8601String()}$sign$hours:$minutes';
  }

  @override
  Future<PaginatedResult<AppointmentEntity>> getMyAppointments({
    int page = 1,
  }) async => (await _remote.getMyAppointments(page: page)).map(
    (appointment) => AppointmentEntity(
      id: appointment.id,
      date: appointment.date,
      status: appointment.status,
      bookingReference: appointment.bookingReference,
      serviceName: appointment.serviceName,
    ),
  );

  @override
  Future<void> cancelAppointment(String id) => _remote.cancelAppointment(id);
}
