class TrainingProgramEntity {
  const TrainingProgramEntity({
    required this.id,
    required this.slug,
    required this.titleEn,
    required this.titleBn,
    this.descriptionEn,
    this.descriptionBn,
    this.curriculum,
    this.durationTextEn,
    this.durationTextBn,
    this.deliveryMode,
    this.price,
    this.currency,
    this.imageUrl,
  });

  final int id;
  final String slug;
  final String titleEn;
  final String titleBn;
  final String? descriptionEn;
  final String? descriptionBn;
  final Object? curriculum;
  final String? durationTextEn;
  final String? durationTextBn;
  final String? deliveryMode;
  final num? price;
  final String? currency;
  final String? imageUrl;

  String titleFor(String languageCode) =>
      languageCode == 'bn' ? (titleBn.isNotEmpty ? titleBn : titleEn) : titleEn;

  String? descriptionFor(String languageCode) {
    final localized = languageCode == 'bn' ? descriptionBn : descriptionEn;
    return localized?.isNotEmpty == true
        ? localized
        : (languageCode == 'bn' ? descriptionEn : descriptionBn);
  }
}
