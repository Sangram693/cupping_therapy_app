import '../../../../core/network/paginated_result.dart';
import '../entities/training_program_entity.dart';

abstract class TrainingRepository {
  const TrainingRepository();

  Future<PaginatedResult<TrainingProgramEntity>> getPrograms({int page = 1});
  Future<TrainingProgramEntity> getProgram(String slug);
  Future<Map<String, dynamic>> submitEnrollment({
    required int programId,
    required String name,
    required String phone,
    String? email,
  });
  Future<PaginatedResult<Map<String, dynamic>>> getMyEnrollments({
    int page = 1,
  });
}
