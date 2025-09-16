import 'package:dio/dio.dart';
import '../../../../core/utils/results.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Result<AuthResponseModel>> login(String email,
      String password,
      String loginBy,) async {
    return await authRemoteDataSource.login(email, password, loginBy);
  }

  @override
  Future<Response> signup(Map<String, dynamic> userData) async {
    return await authRemoteDataSource.signup(userData);
  }

  @override
  Future<AuthResponseModel> socialLogin({required String socialProvider,
    required String name,
    required String email,
    required String provider,
    access_token = "",
    secret_token = "",
  }) async {
    return await authRemoteDataSource.socialLogin(
        socialProvider: socialProvider,
        name: name,
        email: email,
        provider: provider,
        secret_token: secret_token,
        access_token: access_token);
  }

  @override
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }

  @override
  Future<void> forgetPassword(String email) async {
    await authRemoteDataSource.forgetPassword(email);
  }

  @override
  Future<void> confirmResetPassword(String email,
      String code,
      String password,) async {
    await authRemoteDataSource.confirmResetPassword(email, code, password);
  }

  @override
  Future<void> resendCode(String email) async {
    await authRemoteDataSource.resendCode(email);
  }

  @override
  Future<void> confirmCode(String email, String code) async {
    await authRemoteDataSource.confirmCode(email, code);
  }


}
