class TrainingProgramModel {
  const TrainingProgramModel({required this.id, required this.title});

  final String id;
  final String title;

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
