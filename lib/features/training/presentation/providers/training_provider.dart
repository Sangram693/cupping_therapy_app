import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/network/paginated_result.dart';
import '../../domain/entities/training_program_entity.dart';

final selectedTrainingProvider = StateProvider<String>((ref) => '');

final trainingProgramsProvider =
    FutureProvider.family<PaginatedResult<TrainingProgramEntity>, int>(
      (ref, page) =>
          ref.watch(trainingRepositoryProvider).getPrograms(page: page),
    );

final myTrainingEnrollmentsProvider =
    FutureProvider.family<PaginatedResult<Map<String, dynamic>>, int>(
      (ref, page) =>
          ref.watch(trainingRepositoryProvider).getMyEnrollments(page: page),
    );

final trainingEnrollmentProvider =
    StateNotifierProvider<TrainingEnrollmentController, AsyncValue<void>>(
      (ref) => TrainingEnrollmentController(ref),
    );

class TrainingEnrollmentController extends StateNotifier<AsyncValue<void>> {
  TrainingEnrollmentController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<Map<String, dynamic>> submit({
    required int programId,
    required String name,
    required String phone,
    String? email,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await _ref
          .read(trainingRepositoryProvider)
          .submitEnrollment(
            programId: programId,
            name: name,
            phone: phone,
            email: email,
          );
      state = const AsyncData(null);
      _ref.invalidate(myTrainingEnrollmentsProvider);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
