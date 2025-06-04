import 'package:get/get.dart';
import '../main.dart'; // For $sharedPrefsManager, navigate
import '../models/user.dart'; // For User model
import '../pages/auth/login_page.dart';
import '../pages/auth/startup.dart';
import 'api_service.dart';

class AuthService extends GetxController {
  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    if (response != null) {
      final accessToken = response['access_token'] as String?;
      final refreshToken = response['refresh_token'] as String?;
      final userData = response['user'] as Map<String, dynamic>?;

      if (accessToken != null && refreshToken != null && userData != null) {
        final user = User.fromJson(userData);
        await $sharedPrefsManager.setAccessToken(accessToken);
        await $sharedPrefsManager.setRefreshToken(refreshToken);
        await $sharedPrefsManager.setProfile(user.profile ?? user.email);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String email, String password, String? profile) async {
    final response = await _apiService.register(email, password, profile);
    if (response != null) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await $sharedPrefsManager.clearTokens();
    await $sharedPrefsManager.clearProfile();
    Get.offAll(() => const Startup(), transition: Transition.fadeIn);
  }
}
