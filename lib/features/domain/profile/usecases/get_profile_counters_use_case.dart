import '../../../data/profile/models/profile_counters_model.dart';
import '../repositories/profile_repository.dart';

class GetProfileCountersUseCase {
  final ProfileRepository _repository;

  GetProfileCountersUseCase(this._repository);

  Future<ProfileCountersModel> call() async {
    return await _repository.getProfileCounters();
  }
}
