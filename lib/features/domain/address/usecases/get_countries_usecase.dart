import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetCountriesUseCase {
  final AddressRepository repository;
  GetCountriesUseCase(this.repository);
  Future<List<Location>> call({String name = ''}) async {
    return await repository.getCountries(name: name);
  }
}