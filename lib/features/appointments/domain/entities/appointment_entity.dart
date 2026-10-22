class AppointmentEntity {
  const AppointmentEntity({
    required this.id,
    required this.date,
    required this.status,
    this.bookingReference,
    this.serviceName,
  });

  final String id;
  final DateTime date;
  final String status;
  final String? bookingReference;
  final String? serviceName;
}
