import '../../domain/repositories/therapy_repository.dart';
import '../../domain/entities/therapy_service_entity.dart';
import '../datasources/therapy_remote_data_source.dart';
import '../../../../core/network/paginated_result.dart';

class TherapyRepositoryImpl implements TherapyRepository {
  const TherapyRepositoryImpl(this._remote);

  final TherapyRemoteDataSource _remote;

  @override
  Future<PaginatedResult<TherapyServiceEntity>> getServices({
    int page = 1,
  }) async {
    final result = await _remote.getServices(page: page);
    return result.map(
      (service) => TherapyServiceEntity(
        id: service.id,
        slug: service.slug,
        nameEn: service.nameEn,
        nameBn: service.nameBn,
        descriptionEn: service.descriptionEn,
        descriptionBn: service.descriptionBn,
        durationMinutes: service.durationMinutes,
        price: service.price,
        currency: service.currency,
        imageUrl: service.imageUrl,
      ),
    );
  }

  @override
  Future<TherapyServiceEntity> getService(String slug) async {
    final service = await _remote.getService(slug);
    return TherapyServiceEntity(
      id: service.id,
      slug: service.slug,
      nameEn: service.nameEn,
      nameBn: service.nameBn,
      descriptionEn: service.descriptionEn,
      descriptionBn: service.descriptionBn,
      durationMinutes: service.durationMinutes,
      price: service.price,
      currency: service.currency,
      imageUrl: service.imageUrl,
    );
  }
}
