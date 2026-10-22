class TherapyServiceEntity {
  const TherapyServiceEntity({
    required this.id,
    required this.slug,
    required this.nameEn,
    required this.nameBn,
    this.descriptionEn,
    this.descriptionBn,
    this.durationMinutes,
    this.price,
    this.currency,
    this.imageUrl,
  });

  final int id;
  final String slug;
  final String nameEn;
  final String nameBn;
  final String? descriptionEn;
  final String? descriptionBn;
  final int? durationMinutes;
  final num? price;
  final String? currency;
  final String? imageUrl;

  String nameFor(String languageCode) =>
      languageCode == 'bn' ? (nameBn.isNotEmpty ? nameBn : nameEn) : nameEn;

  String? descriptionFor(String languageCode) {
    final localized = languageCode == 'bn' ? descriptionBn : descriptionEn;
    return localized?.isNotEmpty == true
        ? localized
        : (languageCode == 'bn' ? descriptionEn : descriptionBn);
  }
}
