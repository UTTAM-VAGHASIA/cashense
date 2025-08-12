import 'package:dio/dio.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/logging/logger.dart';
import 'package:cashense/utils/helpers/network_helper.dart';

/// Dio HTTP client configuration and setup
class DioClient {
  static Dio? _dio;

  /// Get configured Dio instance
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final dio = Dio();

    // Base configuration
    dio.options = BaseOptions(
      baseUrl: FlavorConfig.instance.settings.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    dio.interceptors.addAll([
      _LoggingInterceptor(),
      _AuthInterceptor(),
      _ErrorInterceptor(),
      if (FlavorConfig.instance.settings.enableLogging)
        _NetworkLogInterceptor(),
    ]);

    return dio;
  }

  /// Reset Dio instance (useful for testing or configuration changes)
  static void reset() {
    _dio?.close();
    _dio = null;
  }

  /// Update base URL
  static void updateBaseUrl(String baseUrl) {
    instance.options.baseUrl = baseUrl;
  }

  /// Update default headers
  static void updateHeaders(Map<String, String> headers) {
    instance.options.headers.addAll(headers);
  }

  /// Remove header
  static void removeHeader(String key) {
    instance.options.headers.remove(key);
  }

  /// Set authorization token
  static void setAuthToken(String token) {
    instance.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token
  static void removeAuthToken() {
    instance.options.headers.remove('Authorization');
  }
}

/// Logging interceptor for debugging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.network(
      options.method,
      options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.network(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
      response: response.data?.toString(),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'Network Error: ${err.message}',
      tag: 'Network',
      error: err,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}

/// Authentication interceptor
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authentication logic here
    // For example, get token from storage and add to headers
    // final token = StorageHelper.getSecureString('auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      AppLogger.auth('Token expired or invalid');

      // Navigate to login screen
      // Get.offAllNamed('/login');

      // Clear stored token
      // StorageHelper.removeSecure('auth_token');
    }

    super.onError(err, handler);
  }
}

/// Error handling interceptor
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = NetworkHelper.handleDioError(err);

    // Show error message to user based on error type
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        // Don't show snackbar for network errors, let the calling code handle it
        break;
      case DioExceptionType.badResponse:
        if (err.response?.statusCode != 401) {
          // Don't show snackbar for auth errors, they're handled by AuthInterceptor
          _showErrorSnackbar('Server Error', errorMessage);
        }
        break;
      case DioExceptionType.cancel:
        // Request was cancelled, don't show error
        break;
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        _showErrorSnackbar('Network Error', errorMessage);
        break;
    }

    super.onError(err, handler);
  }

  void _showErrorSnackbar(String title, String message) {
    // Import and use SnackbarHelper here if needed
    // SnackbarHelper.showError(title: title, message: message);
  }
}

/// Network logging interceptor for detailed logging
class _NetworkLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    options.extra['start_time'] = startTime;

    AppLogger.debug(
      '🚀 Request Started: ${options.method} ${options.uri}',
      tag: 'Network',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    AppLogger.performance(
      'Network Request',
      duration,
      metrics: {
        'method': response.requestOptions.method,
        'url': response.requestOptions.uri.toString(),
        'status_code': response.statusCode,
        'response_size': response.data?.toString().length ?? 0,
      },
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    AppLogger.error(
      '❌ Request Failed: ${err.requestOptions.method} ${err.requestOptions.uri}',
      tag: 'Network',
      error: err,
    );

    AppLogger.performance(
      'Failed Network Request',
      duration,
      metrics: {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'error_type': err.type.toString(),
        'status_code': err.response?.statusCode,
      },
    );

    super.onError(err, handler);
  }
}

/// Extension methods for Dio
extension DioExtensions on Dio {
  /// GET request with error handling
  Future<Response<T>?> safeGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.error('GET request failed: $path', error: e);
      return null;
    }
  }

  /// POST request with error handling
  Future<Response<T>?> safePost<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.error('POST request failed: $path', error: e);
      return null;
    }
  }

  /// PUT request with error handling
  Future<Response<T>?> safePut<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      AppLogger.error('PUT request failed: $path', error: e);
      return null;
    }
  }

  /// DELETE request with error handling
  Future<Response<T>?> safeDelete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      AppLogger.error('DELETE request failed: $path', error: e);
      return null;
    }
  }
}
