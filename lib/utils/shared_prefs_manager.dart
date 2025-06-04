import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _profileKey = 'user_profile';

  String? _accessToken;
  String? _refreshToken;
  String? _profile;

  // Private constructor
  SharedPrefsManager._internal();

  // Singleton instance
  static final SharedPrefsManager _instance = SharedPrefsManager._internal();

  // Factory constructor to return the singleton instance
  factory SharedPrefsManager() {
    return _instance;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_accessTokenKey);
    _refreshToken = prefs.getString(_refreshTokenKey);
    _profile = prefs.getString(_profileKey);
  }

  bool isLoggedIn() {
    return _accessToken != null && _accessToken!.isNotEmpty;
  }

  String? getAccessToken() {
    return _accessToken;
  }

  String? getRefreshToken() {
    return _refreshToken;
  }

  String? getProfile() {
    return _profile;
  }

  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> setRefreshToken(String token) async {
    _refreshToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  Future<void> setProfile(String profile) async {
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<void> clearProfile() async {
    _profile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
