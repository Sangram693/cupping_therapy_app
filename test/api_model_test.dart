import 'package:cupping_therapy/features/home/data/models/home_gallery_image_model.dart';
import 'package:cupping_therapy/features/therapy/data/models/therapy_service_model.dart';
import 'package:cupping_therapy/features/training/data/models/training_program_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses nullable service fields and falls back across locales', () {
    final service = TherapyServiceModel.fromJson({
      'id': 3,
      'slug': 'sample-service',
      'name_en': 'Sample service',
      'name_bn': null,
      'description_en': 'Service information',
      'description_bn': null,
      'duration_minutes': null,
      'price': null,
      'currency': 'INR',
      'image': null,
    });

    expect(service.id, 3);
    expect(service.durationMinutes, isNull);
    expect(service.price, isNull);
    expect(service.imageUrl, isNull);
    expect(service.nameBn, '');
  });

  test('parses localized program fields and optional curriculum', () {
    final program = TrainingProgramModel.fromJson({
      'id': 8,
      'slug': 'sample-training',
      'title_en': 'Sample training',
      'title_bn': 'নমুনা প্রশিক্ষণ',
      'description_en': 'Description',
      'description_bn': null,
      'curriculum': null,
      'duration_text_en': null,
      'duration_text_bn': null,
      'delivery_mode': null,
      'price': null,
      'currency': 'INR',
      'image': null,
    });

    expect(program.titleBn, 'নমুনা প্রশিক্ষণ');
    expect(program.curriculum, isNull);
    expect(program.imageUrl, isNull);
  });

  test('keeps a gallery entry with no media URL renderable', () {
    final image = HomeGalleryImageModel.fromJson({
      'id': 7,
      'sort_order': 1,
      'media': {
        'id': 18,
        'url': null,
        'alt_text_en': 'Therapy room',
        'alt_text_bn': null,
      },
    });

    expect(image.entity.mediaId, '18');
    expect(image.entity.url, isEmpty);
    expect(image.entity.altTextFor('bn', 'fallback'), 'fallback');
  });
}
