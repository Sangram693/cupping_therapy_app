import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/network/paginated_result.dart';
import '../../domain/entities/therapy_service_entity.dart';

final selectedTherapyProvider = StateProvider<String>((ref) => '');

final therapyServicesProvider =
    FutureProvider.family<PaginatedResult<TherapyServiceEntity>, int>(
      (ref, page) =>
          ref.watch(therapyRepositoryProvider).getServices(page: page),
    );
