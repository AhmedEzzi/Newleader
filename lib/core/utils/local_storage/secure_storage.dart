import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  static const _storage = FlutterSecureStorage();

  SecureStorage._internal();

  Future<void> save<T>(String key, T value) async {
    if (value is String) {
      await _storage.write(key: key, value: value);
    } else if (value is bool) {
      await _storage.write(key: key, value: value.toString());
    } else if (value is int) {
      await _storage.write(key: key, value: value.toString());
    } else {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }
  }

  Future<T?> get<T>(String key) async {
    final value = await _storage.read(key: key);

    if (value == null) {
      return null;
    }

    if (T == String) {
      return value as T;
    } else if (T == bool) {
      return (value == 'true') as T;
    } else if (T == int) {
      return int.parse(value) as T;
    } else if (T == double) {
      return double.parse(value) as T;
    } else {
      throw ArgumentError('Unsupported type: $T');
    }
  }

  /// Delete a specific key
  Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all stored data
  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }


}


///How to use
// Retrieve a string
// String? token = await secureStorage.get<String>('auth_token');
//
// // Retrieve a boolean
// bool hasOnboarded = await secureStorage.get<bool>('has_completed_onboarding') ?? false;
//
// // Retrieve an integer
// int userId = await secureStorage.get<int>('user_id') ?? 0;