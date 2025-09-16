import 'package:dio/dio.dart';

import '../../../../core/utils/results.dart';
import '../../../data/auth/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<Result<AuthResponseModel>> login(String email, String password, String loginBy);
  Future<Response> signup(Map<String, dynamic> userData);
  Future<AuthResponseModel> socialLogin( {required String socialProvider,
  required String name,
  required String email,
  required String provider,
        access_token = "",
        secret_token = "",
      });
  Future<void> logout();
  Future<void> forgetPassword(String email);
  Future<void> confirmResetPassword(String email, String code, String password);
  Future<void> resendCode(String email);
  Future<void> confirmCode(String email, String code);
}
