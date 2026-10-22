import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../domain/entities/home_gallery_image_entity.dart';

final homeTabIndexProvider = StateProvider<int>((ref) => 0);

final homeGalleryProvider = FutureProvider<List<HomeGalleryImageEntity>>(
  (ref) => ref.watch(homeGalleryRepositoryProvider).getAllImages(),
);

final contactInquiryProvider =
    StateNotifierProvider<ContactInquiryController, AsyncValue<void>>(
      (ref) => ContactInquiryController(ref),
    );

class ContactInquiryController extends StateNotifier<AsyncValue<void>> {
  ContactInquiryController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> submit({
    required String name,
    required String phone,
    String? email,
    String? subject,
    required String message,
  }) async {
    state = const AsyncLoading();
    try {
      await _ref
          .read(contactInquiryRepositoryProvider)
          .submit(
            name: name,
            phone: phone,
            email: email,
            subject: subject,
            message: message,
          );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
