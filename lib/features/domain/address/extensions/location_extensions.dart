import '../entities/address.dart';

extension LocationExtensions on Location {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'code': code,
      'status': status,
      'stateId': stateId,
    };
  }
}
