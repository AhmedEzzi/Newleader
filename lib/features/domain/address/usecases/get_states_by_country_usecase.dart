import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetStatesByCountryUseCase {
  final AddressRepository repository;
  GetStatesByCountryUseCase(this.repository);
  Future<List<Location>> call(int countryId, {String name = ''}) async {
    return await repository.getStatesByCountry(countryId, name: name);
  }
}