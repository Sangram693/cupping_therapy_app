import '../../../../core/utils/api_media_url.dart';

class TrainingProgramModel {
  const TrainingProgramModel({
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

  factory TrainingProgramModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final id = _int(json['id']);
    if (id <= 0 || json['slug'] == null) {
      throw const FormatException('Invalid training program resource.');
    }
    return TrainingProgramModel(
      id: id,
      slug: json['slug']?.toString() ?? '',
      titleEn: json['title_en']?.toString() ?? '',
      titleBn: json['title_bn']?.toString() ?? '',
      descriptionEn: json['description_en'] as String?,
      descriptionBn: json['description_bn'] as String?,
      curriculum: json['curriculum'],
      durationTextEn: json['duration_text_en'] as String?,
      durationTextBn: json['duration_text_bn'] as String?,
      deliveryMode: json['delivery_mode'] as String?,
      price: json['price'] is num
          ? json['price'] as num
          : num.tryParse('${json['price'] ?? ''}'),
      currency: json['currency'] as String?,
      imageUrl: ApiMediaUrl.resolve(image is Map ? image['url'] : image),
    );
  }

  static int _int(Object? value) =>
      value is int ? value : int.tryParse('$value') ?? 0;
}
