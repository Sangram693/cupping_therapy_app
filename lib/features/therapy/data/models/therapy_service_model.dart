import '../../../../core/utils/api_media_url.dart';

class TherapyServiceModel {
  const TherapyServiceModel({
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

  factory TherapyServiceModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    final id = _int(json['id']);
    if (id <= 0 || json['slug'] == null) {
      throw const FormatException('Invalid therapy service resource.');
    }
    return TherapyServiceModel(
      id: id,
      slug: json['slug']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameBn: json['name_bn']?.toString() ?? '',
      descriptionEn: json['description_en'] as String?,
      descriptionBn: json['description_bn'] as String?,
      durationMinutes: json['duration_minutes'] is num
          ? (json['duration_minutes'] as num).toInt()
          : null,
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
