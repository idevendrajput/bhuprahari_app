import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../components/global_snackbar.dart';
import '../main.dart'; // For global accessors ($apiClient, $logger, snackBar, GlobalSnackbarHelper)
import '../models/area_config.dart';
import '../models/image_tile.dart';
import '../models/alert_session.dart';
import '../models/alert_detail.dart';
import '../models/user.dart';
import '../network/dio_client.dart'; // For User model in auth responses

class ApiService {
  final Dio _dio = DioClient().dio; // Use the instance from DioClient

  // --- Auth APIs ---
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      $logger.error("Error logging in: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> register(String email, String password, String? profile) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'profile': profile,
      });
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioException catch (e) {
      $logger.error("Error registering: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return null;
  }

  // --- AreaConfig APIs ---
  Future<AreaConfig?> createAreaConfig(AreaConfig areaConfig) async {
    try {
      final response = await _dio.post('/area-configs/', data: areaConfig.toJson());
      if (response.statusCode == 201) {
        return AreaConfig.fromJson(response.data);
      }
    } on DioException catch (e) {
      $logger.error("Error creating area config: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return null;
  }

  Future<List<AreaConfig>> getAllAreaConfigs() async {
    try {
      final response = await _dio.get('/area-configs/');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => AreaConfig.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      $logger.error("Error fetching area configs: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return [];
  }

  Future<AreaConfig?> getAreaConfig(int id) async {
    try {
      final response = await _dio.get('/area-configs/$id');
      if (response.statusCode == 200) {
        return AreaConfig.fromJson(response.data);
      }
    } on DioException catch (e) {
      $logger.error("Error fetching area config by ID: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return null;
  }

  // --- Monitor APIs ---
  Future<bool> triggerImageCapture(int areaConfigId) async {
    try {
      final response = await _dio.post('/monitor/capture/$areaConfigId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      $logger.error("Error triggering image capture: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return false;
  }

  Future<bool> triggerImageComparison(int areaConfigId) async {
    try {
      final response = await _dio.post('/monitor/compare/$areaConfigId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      $logger.error("Error triggering image comparison: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return false;
  }

  Future<List<ImageTile>> getAreaImageTiles(int areaConfigId) async {
    try {
      final response = await _dio.get('/monitor/image-tiles/area/$areaConfigId');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => ImageTile.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      $logger.error("Error fetching image tiles for area: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return [];
  }

  // --- Alert APIs ---
  Future<List<AlertSession>> getAlertSessions() async {
    try {
      final response = await _dio.get('/alerts/sessions');
      if (response.statusCode == 200) {
        return (response.data as List).map((json) => AlertSession.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      $logger.error("Error fetching alert sessions: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return [];
  }

  Future<Map<String, dynamic>?> getAlertSessionDetails(int sessionId) async {
    try {
      final response = await _dio.get('/alerts/sessions/$sessionId/details');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      $logger.error("Error fetching alert session details: ${e.message}", e);
      if (e.response != null) {
        $logger.error("Response data: ${e.response?.data}");
        GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.failed);
      } else {
        GlobalSnackbarHelper.showSnackbar($strings.error, $strings.failed);
      }
    }
    return null;
  }
}
