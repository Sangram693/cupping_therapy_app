class TherapyServiceModel {
  const TherapyServiceModel({required this.id, required this.name});

  final String id;
  final String name;

  factory TherapyServiceModel.fromJson(Map<String, dynamic> json) {
    return TherapyServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
