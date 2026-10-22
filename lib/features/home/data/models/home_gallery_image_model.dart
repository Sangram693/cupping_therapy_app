import '../../domain/entities/home_gallery_image_entity.dart';
import '../../../../core/utils/api_media_url.dart';

class HomeGalleryImageModel {
  const HomeGalleryImageModel(this.entity);

  final HomeGalleryImageEntity entity;

  factory HomeGalleryImageModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'];
    final id = json['id'];
    if (id == null || media is! Map || media['id'] == null) {
      throw const FormatException('Invalid home gallery resource.');
    }
    final mediaMap = Map<String, dynamic>.from(media);
    final rawUrl = mediaMap['url'];
    return HomeGalleryImageModel(
      HomeGalleryImageEntity(
        id: '$id',
        mediaId: '${mediaMap['id']}',
        url: ApiMediaUrl.resolve(rawUrl) ?? '',
        sortOrder: json['sort_order'] is num
            ? (json['sort_order'] as num).toInt()
            : 0,
        altTextEn: mediaMap['alt_text_en'] as String?,
        altTextBn: mediaMap['alt_text_bn'] as String?,
      ),
    );
  }
}
