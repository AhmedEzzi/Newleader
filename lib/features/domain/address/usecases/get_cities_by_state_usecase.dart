import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetCitiesByStateUseCase {
  final AddressRepository repository;
  GetCitiesByStateUseCase(this.repository);
  Future<List<Location>> call(int stateId, {String name = ''}) async {
    return await repository.getCitiesByState(stateId, name: name);
  }
}