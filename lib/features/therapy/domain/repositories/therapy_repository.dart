import '../../../../core/network/paginated_result.dart';
import '../entities/therapy_service_entity.dart';

abstract class TherapyRepository {
  const TherapyRepository();

  Future<PaginatedResult<TherapyServiceEntity>> getServices({int page = 1});
  Future<TherapyServiceEntity> getService(String slug);
}
