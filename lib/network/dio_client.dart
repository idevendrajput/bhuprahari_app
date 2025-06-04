import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../components/global_snackbar.dart';
import '../main.dart'; // For $sharedPrefsManager, $strings, $logger, navigate
import '../pages/auth/login_page.dart';
import '../pages/auth/startup.dart'; // For logout navigation

class DioClient {
  final Dio _dio = Dio(BaseOptions(validateStatus: (statusCode) {
    if (statusCode == null) {
      return false;
    }
    // Treat 401 and 422 as valid responses to handle them in onResponse/onError
    if (statusCode == 422 || statusCode == 401 || statusCode == 500) {
      return true;
    } else {
      return statusCode >= 200 && statusCode < 300;
    }
  }));

  // --- IMPORTANT: Update this to your deployed Python backend URL ---
  static const String rootUrl = 'http://69.62.85.159/'; // Your VPS IP or domain
  static const String baseUrl = '${rootUrl}api/'; // All APIs are under /api/

  Dio get dio {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 5);
    _dio.options.receiveTimeout = const Duration(minutes: 5);

    setupInterceptors();

    return _dio;
  }

  void setupInterceptors() {
    _dio.interceptors.clear(); // Clear existing interceptors to prevent duplicates
    _dio.interceptors.add(LogInterceptor(requestHeader: true, requestBody: true, request: true, responseBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        await $sharedPrefsManager.init(); // Ensure tokens are loaded
        final token = $sharedPrefsManager.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers[$strings.AUTHORIZATION] = "${$strings.BEARER} $token";
          $logger.log("Token: $token");
          $logger.log("*********** REQUEST **********");
          $logger.printObj(options.data);
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        $logger.log("Response data: ${response.data}");
        $logger.log("Response status code: ${response.statusCode}");
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        $logger.error("Error: ${e.response?.data}");
        $logger.error("Error status code: ${e.response?.statusCode}");

        if (e.response?.statusCode == 401) {
          // Unauthorized - token expired or invalid
          await $sharedPrefsManager.clearTokens();
          Get.offAll(() => const Startup(), transition: Transition.fadeIn);
          GlobalSnackbarHelper.showSnackbar($strings.error, "Session expired. Please login again.");
        } else if (e.response?.statusCode == 500) {
          // Internal Server Error
          GlobalSnackbarHelper.showSnackbar($strings.error, e.response?.data['message'] ?? $strings.internalServerError);
        }
        return handler.next(e);
      },
    ));
  }
}
