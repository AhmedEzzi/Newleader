import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:leader_company/core/utils/constants/app_strings.dart';
import 'package:leader_company/core/utils/extension/translate_extension.dart';
import '../../../../core/api/api_exceptions.dart';
import '../../../../core/api/api_provider.dart';
import '../../../../core/api/rest_api_provider.dart';
import '../../../../core/utils/local_storage/local_storage_keys.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';
import '../../../../core/utils/results.dart';
import '../../../data/auth/models/auth_response_model.dart';
import '../../../domain/auth/usecases/auth/confirm_code_use_case.dart';
import '../../../domain/auth/usecases/auth/confirm_reset_password_use_case.dart';
import '../../../domain/auth/usecases/auth/forget_password_use_case.dart';
import '../../../domain/auth/usecases/auth/login_use_case.dart';
import '../../../domain/auth/usecases/auth/logout_use_case.dart';
import '../../../domain/auth/usecases/auth/resend_code_use_case.dart';
import '../../../domain/auth/usecases/auth/signup_use_case.dart';
import '../../../domain/auth/usecases/auth/social_login_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final SocialLoginUseCase socialLoginUseCase;
  final LogoutUseCase logoutUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final ConfirmResetPasswordUseCase confirmResetPasswordUseCase;
  final ResendCodeUseCase resendCodeUseCase;
  final ConfirmCodeUseCase confirmCodeUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.socialLoginUseCase,
    required this.logoutUseCase,
    required this.forgetPasswordUseCase,
    required this.confirmResetPasswordUseCase,
    required this.resendCodeUseCase,
    required this.confirmCodeUseCase,
  });

  bool _isLoading = false;
  AuthResponseModel? _user;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  AuthResponseModel? get user => _user;

  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setRequestMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(
      String email,
      String password,
      String loginBy,
      BuildContext context,
      ) async {
    _setLoading(true);
    bool isSuccess = false;
    try {
      final result = await loginUseCase(email, password, loginBy);
      if (result is Success<AuthResponseModel>) {
        _user = result.data;
        // Set token in AppStrings
        AppStrings.token = _user!.accessToken!;
        AppStrings.userName = _user!.user!.name;
        AppStrings.userId = _user!.user!.id.toString();
        AppStrings.userEmail = _user!.user!.email.toString();

        // Save to secure storage
        await SecureStorage().save(
          LocalStorageKey.userToken,
          _user!.accessToken!,
        );
        await SecureStorage().save(LocalStorageKey.userName, _user!.user!.name);
        await SecureStorage().save(LocalStorageKey.userId, _user!.user!.id);
        await SecureStorage().save(
          LocalStorageKey.userEmail,
          _user!.user!.email,
        );

        final apiProvider = GetIt.instance<ApiProvider>();
        if (apiProvider is RestApiProvider) {
          apiProvider.setAuthToken(_user!.accessToken!);
        }

        isSuccess = true;
        _setRequestMessage(result.data.message);
      } else if (result is Failure<AuthResponseModel>) {
        _setRequestMessage(result.message);
      }
    } on UserNotFoundException catch (e) {
      _setRequestMessage(e.message);
    } on UnauthorizedException catch (e) {
      _setRequestMessage('invalid_credentials'.tr(context));
    } catch (e) {
      _setRequestMessage(e.toString());
    }
    _setLoading(false);
    return isSuccess;
  }

  Future<bool> signup(
      Map<String, dynamic> userData,
      BuildContext context,
      ) async {
    _setLoading(true);
    bool isSuccess = false;
    try {
      Response response = await signupUseCase(userData);
      if (response.data['result']) {
        _user = AuthResponseModel.fromJson(response.data);

        isSuccess = true;
        _setRequestMessage(response.data['message']);
      } else {
        _setRequestMessage(response.data['message']);
      }
    } catch (e) {
      _setRequestMessage('invalid_credentials'.tr(context));
      print("Signup Error: $e");
    }
    _setLoading(false);
    return isSuccess;
  }

  // Add this method to complete social login flow
  Future<bool> completeSocialLogin({
    required String name,

    required String email,
    required String socialProvider,
    required String provider,
    access_token = "",
    secret_token = "",
  }) async {
    _setLoading(true);
    try {
      final authResponse = await socialLoginUseCase(
        provider: provider,
        socialProvider: socialProvider,
        name: name,
        email: email,
        secret_token: secret_token,
        access_token: access_token,
      );
      if (authResponse.result) {
        _user = authResponse;

        // Set token in AppStrings
        AppStrings.token = _user!.accessToken!;
        AppStrings.userName = _user!.user!.name;
        AppStrings.userId = _user!.user!.id.toString();
        AppStrings.userEmail = _user!.user!.email.toString();

        // Save to secure storage
        await SecureStorage().save(
          LocalStorageKey.userToken,
          _user!.accessToken!,
        );
        await SecureStorage().save(LocalStorageKey.userName, _user!.user!.name);
        await SecureStorage().save(
          LocalStorageKey.userId,
          _user!.user!.id.toString(),
        );
        await SecureStorage().save(
          LocalStorageKey.userEmail,
          _user!.user!.email.toString(),
        );

        // Update API provider
        final apiProvider = GetIt.instance<ApiProvider>();
        if (apiProvider is RestApiProvider) {
          apiProvider.setAuthToken(_user!.accessToken!);
        }

        _setLoading(false);
        return true;
      } else {
        _setRequestMessage(authResponse.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setRequestMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await logoutUseCase();
      _user = null;

      // Clear AppStrings values
      AppStrings.token = null;
      AppStrings.userId = null;
      AppStrings.userName = null;
      AppStrings.userEmail = null;

      // Clear secure storage
      await SecureStorage().deleteKey(LocalStorageKey.userToken);
      await SecureStorage().deleteKey(LocalStorageKey.userEmail);
      await SecureStorage().deleteKey(LocalStorageKey.userId);
      await SecureStorage().deleteKey(LocalStorageKey.userName);

      // Reset the auth token in the API provider
      final apiProvider = GetIt.instance<ApiProvider>();
      if (apiProvider is RestApiProvider) {
        apiProvider.setAuthToken('');
      }
    } catch (e) {
      print("Logout Error: $e");
    }
    _setLoading(false);
  }

  Future<void> forgetPassword(String email) async {
    _setLoading(true);
    try {
      await forgetPasswordUseCase(email);
    } catch (e) {
      print("Forget Password Error: $e");
    }
    _setLoading(false);
  }

  Future<void> confirmResetPassword(
      String email,
      String code,
      String password,
      ) async {
    _setLoading(true);
    try {
      await confirmResetPasswordUseCase(email, code, password);
    } catch (e) {
      print("Confirm Reset Password Error: $e");
    }
    _setLoading(false);
  }

  Future<void> resendCode(String email) async {
    _setLoading(true);
    try {
      await resendCodeUseCase(email);
    } catch (e) {
      print("Resend Code Error: $e");
    }
    _setLoading(false);
  }

  Future<void> confirmCode(String email, String code) async {
    _setLoading(true);
    try {
      await confirmCodeUseCase(email, code);
    } catch (e) {
      print("Confirm Code Error: $e");
    }
    _setLoading(false);
  }
}
