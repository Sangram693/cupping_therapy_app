import '../../../../core/network/paginated_result.dart';
import '../../domain/entities/home_gallery_image_entity.dart';
import '../datasources/home_gallery_remote_data_source.dart';

class HomeGalleryRepositoryImpl {
  const HomeGalleryRepositoryImpl(this._remote);

  final HomeGalleryRemoteDataSource _remote;

  Future<List<HomeGalleryImageEntity>> getAllImages() async {
    final images = <HomeGalleryImageEntity>[];
    var pageNumber = 1;
    PaginatedResult<dynamic>? page;
    do {
      final nextPage = await _remote.getGalleryPage(page: pageNumber);
      images.addAll(nextPage.data.map((image) => image.entity));
      page = nextPage;
      pageNumber++;
    } while (page.hasMore);
    images.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return images;
  }
}
