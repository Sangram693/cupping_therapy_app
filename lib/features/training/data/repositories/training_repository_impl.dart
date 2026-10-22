import '../../domain/repositories/training_repository.dart';
import '../../domain/entities/training_program_entity.dart';
import '../datasources/training_remote_data_source.dart';
import '../models/training_program_model.dart';
import '../../../../core/network/paginated_result.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  const TrainingRepositoryImpl(this._remote);

  final TrainingRemoteDataSource _remote;

  @override
  Future<PaginatedResult<TrainingProgramEntity>> getPrograms({
    int page = 1,
  }) async => (await _remote.getPrograms(page: page)).map(_toEntity);

  @override
  Future<TrainingProgramEntity> getProgram(String slug) async =>
      _toEntity(await _remote.getProgram(slug));

  TrainingProgramEntity _toEntity(TrainingProgramModel program) =>
      TrainingProgramEntity(
        id: program.id,
        slug: program.slug,
        titleEn: program.titleEn,
        titleBn: program.titleBn,
        descriptionEn: program.descriptionEn,
        descriptionBn: program.descriptionBn,
        curriculum: program.curriculum,
        durationTextEn: program.durationTextEn,
        durationTextBn: program.durationTextBn,
        deliveryMode: program.deliveryMode,
        price: program.price,
        currency: program.currency,
        imageUrl: program.imageUrl,
      );

  @override
  Future<Map<String, dynamic>> submitEnrollment({
    required int programId,
    required String name,
    required String phone,
    String? email,
  }) => _remote.submitEnrollment({
    'training_program_id': programId,
    'student_name': name,
    'student_phone': phone,
    if (email != null && email.isNotEmpty) 'student_email': email,
  });

  @override
  Future<PaginatedResult<Map<String, dynamic>>> getMyEnrollments({
    int page = 1,
  }) => _remote.getMyEnrollments(page: page);
}
