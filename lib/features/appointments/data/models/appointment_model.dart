class AppointmentModel {
  const AppointmentModel({required this.id, required this.date});

  final String id;
  final DateTime date;

  Map<String, dynamic> toJson() => {'id': id, 'date': date.toIso8601String()};
}
