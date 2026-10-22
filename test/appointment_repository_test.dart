import 'package:cupping_therapy/core/network/paginated_result.dart';
import 'package:cupping_therapy/features/appointments/data/datasources/appointments_remote_data_source.dart';
import 'package:cupping_therapy/features/appointments/data/models/appointment_model.dart';
import 'package:cupping_therapy/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _AppointmentsRemote implements AppointmentsRemoteDataSource {
  Map<String, dynamic>? submittedValues;

  @override
  Future<Map<String, dynamic>> createAppointment(
    Map<String, dynamic> values,
  ) async {
    submittedValues = values;
    return {'booking_reference': 'APT-EXAMPLE', 'status': 'pending'};
  }

  @override
  Future<PaginatedResult<AppointmentModel>> getMyAppointments({
    int page = 1,
  }) async => PaginatedResult<AppointmentModel>(
    data: const [],
    currentPage: page,
    lastPage: page,
    perPage: 15,
    total: 0,
  );

  @override
  Future<void> cancelAppointment(String id) async {}
}

void main() {
  test(
    'sends only documented appointment request fields with timezone offset',
    () async {
      final remote = _AppointmentsRemote();
      final repository = AppointmentsRepositoryImpl(remote);
      final appointmentAt = DateTime(2026, 12, 1, 9);

      final response = await repository.createAppointment(
        serviceId: 3,
        customerName: 'A Customer',
        customerPhone: '+919876543210',
        customerEmail: 'customer@example.test',
        appointmentAt: appointmentAt,
        customerNote: 'Please call to confirm.',
      );

      expect(response['booking_reference'], 'APT-EXAMPLE');
      expect(remote.submittedValues, containsPair('therapy_service_id', 3));
      expect(
        remote.submittedValues,
        containsPair('customer_name', 'A Customer'),
      );
      expect(
        remote.submittedValues,
        containsPair('customer_phone', '+919876543210'),
      );
      expect(
        remote.submittedValues,
        containsPair('customer_email', 'customer@example.test'),
      );
      expect(
        remote.submittedValues,
        containsPair('customer_note', 'Please call to confirm.'),
      );
      expect(remote.submittedValues!.containsKey('status'), isFalse);
      expect(remote.submittedValues!.containsKey('price'), isFalse);
      expect(
        RegExp(r'T\d{2}:\d{2}:\d{2}\.\d{3}[+-]\d{2}:\d{2}$')
            .hasMatch(remote.submittedValues!['appointment_at'] as String),
        isTrue,
      );
    },
  );
}
