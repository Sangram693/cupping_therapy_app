import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_result.dart';
import '../models/home_gallery_image_model.dart';

class HomeGalleryRemoteDataSource {
  const HomeGalleryRemoteDataSource(this._client);

  final ApiClient _client;

  Future<PaginatedResult<HomeGalleryImageModel>> getGalleryPage({
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.homeGallery,
      queryParameters: {'page': page, 'per_page': 100},
    );
    return PaginatedResult.fromJson(
      response.data ?? const {},
      HomeGalleryImageModel.fromJson,
    );
  }
}
