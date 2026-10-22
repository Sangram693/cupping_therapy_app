class HomeGalleryImageEntity {
  const HomeGalleryImageEntity({
    required this.id,
    required this.mediaId,
    required this.url,
    required this.sortOrder,
    this.altTextEn,
    this.altTextBn,
  });

  final String id;
  final String mediaId;
  final String url;
  final int sortOrder;
  final String? altTextEn;
  final String? altTextBn;

  String altTextFor(String languageCode, String fallback) {
    final localized = languageCode == 'bn' ? altTextBn : altTextEn;
    return localized?.isNotEmpty == true ? localized! : fallback;
  }
}
