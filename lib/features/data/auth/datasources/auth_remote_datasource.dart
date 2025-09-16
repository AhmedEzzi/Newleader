import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/results.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<AuthResponseModel>> login(String email, String password, String loginBy);  Future<Response> signup(Map<String, dynamic> userData);
  Future<AuthResponseModel> socialLogin(
      { required String socialProvider,
      required String name,
        required String email,
        required String provider,
        String access_token = "",
        String secret_token = "",
      });
  Future<void> logout();
  Future<void> forgetPassword(String email);
  Future<void> confirmResetPassword(String email, String code, String password);
  Future<void> resendCode(String email);
  Future<void> confirmCode(String email, String code);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiProvider apiProvider;

  AuthRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<Result<AuthResponseModel>> login(String email, String password, String loginBy) async {
    try {
      final response = await apiProvider.post(
        LaravelApiEndPoint.login,
        data: {'email_or_phone': email, 'password': password, 'login_by': loginBy},
      );
      final authResponse = AuthResponseModel.fromJson(response.data);
      if (authResponse.result) {
        return Success(authResponse);
      } else {
        return Failure(authResponse.message);
      }
    } on DioException catch (e) {
      return Failure(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      return Failure('$e');
    }
  }

  @override
  Future<Response> signup(Map<String, dynamic> userData) async {
    final response = await apiProvider.post(LaravelApiEndPoint.signup, data: userData);
    return response;
  }

  @override
  Future<AuthResponseModel> socialLogin({
    required String socialProvider,
    required String name,
    required String email,
    required String provider,
        access_token = "",
        secret_token = "",
      }) async {

    var postBody = jsonEncode({
      "name": name,
      "email": email,
      "provider": provider,
      "social_provider": socialProvider,
      "access_token": access_token,
      "secret_token": secret_token
    });

    print('social login post Body${postBody}');
    final response = await apiProvider.post(
      LaravelApiEndPoint.socialLogin,
      data: postBody,
    );
    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await apiProvider.get(LaravelApiEndPoint.logout);
  }

  @override
  Future<void> forgetPassword(String email) async {
    await apiProvider.post(LaravelApiEndPoint.forgetPassword, data: {'email': email});
  }

  @override
  Future<void> confirmResetPassword(
      String email, String code, String password) async {
    await apiProvider.post(
      LaravelApiEndPoint.resetPassword,
      data: {'email': email, 'code': code, 'password': password},
    );
  }

  @override
  Future<void> resendCode(String email) async {
    await apiProvider.post(LaravelApiEndPoint.resendCode, data: {'email': email});
  }

  @override
  Future<void> confirmCode(String email, String code) async {
    await apiProvider.post(LaravelApiEndPoint.confirmCode, data: {'email': email, 'code': code});
  }

}
