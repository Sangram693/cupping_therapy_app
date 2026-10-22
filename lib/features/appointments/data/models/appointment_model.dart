class AppointmentModel {
  const AppointmentModel({
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final service = json['therapy_service'];
    final id = json['id'];
    final date = DateTime.tryParse('${json['appointment_at'] ?? ''}');
    if (id == null || date == null) {
      throw const FormatException('Invalid appointment resource.');
    }
    return AppointmentModel(
      id: '$id',
      date: date,
      status: json['status']?.toString() ?? 'pending',
      bookingReference: json['booking_reference'] as String?,
      serviceName: service is Map
          ? (service['name_en'] ?? service['name_bn']) as String?
          : null,
    );
  }
}
