import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../data/profile/models/profile_counters_model.dart';
import '../../../data/profile/models/profile_update_response.dart';
import '../../../domain/profile/entities/user_profile.dart';
import '../../../domain/profile/usecases/get_profile_counters_use_case.dart';
import '../../../domain/profile/usecases/get_user_by_access_token_use_case.dart';
import '../../../domain/profile/usecases/get_user_profile_use_case.dart';
import '../../../domain/profile/usecases/update_profile_image_use_case.dart';
import '../../../domain/profile/usecases/update_profile_use_case.dart';

class ProfileProvider extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetUserByAccessTokenUseCase _getUserByAccessTokenUseCase;
  final GetProfileCountersUseCase _getProfileCountersUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateProfileImageUseCase _updateProfileImageUseCase;

  ProfileProvider({
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetUserByAccessTokenUseCase getUserByAccessTokenUseCase,
    required GetProfileCountersUseCase getProfileCountersUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UpdateProfileImageUseCase updateProfileImageUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _getUserByAccessTokenUseCase = getUserByAccessTokenUseCase,
        _getProfileCountersUseCase = getProfileCountersUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _updateProfileImageUseCase = updateProfileImageUseCase;

  // Profile state management
  LoadingState profileState = LoadingState.initial;
  UserProfile? userProfile;
  String profileError = '';
  
  // Profile counters state management
  LoadingState countersState = LoadingState.initial;
  ProfileCountersModel? profileCounters;
  String countersError = '';
  
  // Profile update state management
  LoadingState updateState = LoadingState.initial;
  String updateError = '';
  
  // Profile image
  String? profileImageUrl;

  Future<void> getUserProfile() async {
    if (AppStrings.token == null) return;

    profileState = LoadingState.loading;
    notifyListeners();

    try {
      // Use the new method to get user by access token
      userProfile = await _getUserByAccessTokenUseCase();

      // Check both avatar and avatar_original
      if (userProfile?.avatar != null && userProfile!.avatar.isNotEmpty) {
        profileImageUrl = userProfile!.avatar;
      }

      profileState = LoadingState.loaded;
    } catch (e) {
      profileState = LoadingState.error;
      profileError = 'Failed to load user profile: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> getProfileCounters() async {
    if (AppStrings.token == null) return;
    
    countersState = LoadingState.loading;
    notifyListeners();
    
    try {
      profileCounters = await _getProfileCountersUseCase();
      countersState = LoadingState.loaded;
    } catch (e) {
      countersState = LoadingState.error;
      countersError = 'Failed to load profile counters: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String name, String password) async {
    if (AppStrings.userId == null) return false;
    
    updateState = LoadingState.loading;
    notifyListeners();
    
    try {
      final response = await _updateProfileUseCase(
        AppStrings.userId!,
        name,
        password,
      );
      
      updateState = LoadingState.loaded;
      notifyListeners();
      return response.result;
    } catch (e) {
      updateState = LoadingState.error;
      updateError = 'Failed to update profile: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfileImage(File imageFile) async {
    if (AppStrings.userId == null) return false;
    
    updateState = LoadingState.loading;
    notifyListeners();
    
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final filename = imageFile.path.split('/').last;
      
      final response = await _updateProfileImageUseCase(
        AppStrings.userId!,
        filename,
        base64Image,
      );
      
      if (response.result && response.path != null) {
        profileImageUrl = response.path;
      }
      
      updateState = LoadingState.loaded;
      notifyListeners();
      return response.result;
    } catch (e) {
      updateState = LoadingState.error;
      updateError = 'Failed to update profile image: $e';
      notifyListeners();
      return false;
    }
  }

  void setProfileImageUrl(String url) {
    profileImageUrl = url;
    notifyListeners();
  }
}
