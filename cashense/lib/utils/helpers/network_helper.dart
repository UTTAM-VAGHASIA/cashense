import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:cashense/utils/helpers/snackbar_helper.dart';

/// Helper class for network operations and connectivity checks
class NetworkHelper {
  NetworkHelper._();

  static final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      
      // Check if any connection type is available
      if (connectivityResults.contains(ConnectivityResult.none)) {
        return false;
      }

      // Verify actual internet connectivity by pinging Google DNS
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get current connectivity status
  static Future<List<ConnectivityResult>> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  /// Listen to connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Check if connected to WiFi
  static Future<bool> isConnectedToWiFi() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.wifi);
  }

  /// Check if connected to mobile data
  static Future<bool> isConnectedToMobile() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.mobile);
  }

  /// Show no internet connection snackbar
  static void showNoInternetSnackbar() {
    SnackbarHelper.showError(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
    );
  }

  /// Show connection restored snackbar
  static void showConnectionRestoredSnackbar() {
    SnackbarHelper.showSuccess(
      title: 'Connection Restored',
      message: 'Internet connection has been restored.',
    );
  }

  /// Handle network errors from Dio
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        return _handleHttpError(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Certificate error. Please try again later.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handle HTTP status code errors
  static String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again later.';
      default:
        return 'Server error ($statusCode). Please try again later.';
    }
  }

  /// Get network type as string
  static Future<String> getNetworkType() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    
    if (connectivityResults.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (connectivityResults.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else if (connectivityResults.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else {
      return 'No Connection';
    }
  }

  /// Check if network is metered (mobile data)
  static Future<bool> isNetworkMetered() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.contains(ConnectivityResult.mobile);
  }

  /// Execute function with network check
  static Future<T?> executeWithNetworkCheck<T>(
    Future<T> Function() function, {
    bool showSnackbarOnError = true,
  }) async {
    if (await hasInternetConnection()) {
      try {
        return await function();
      } catch (e) {
        if (showSnackbarOnError) {
          SnackbarHelper.showError(
            title: 'Error',
            message: e.toString(),
          );
        }
        return null;
      }
    } else {
      if (showSnackbarOnError) {
        showNoInternetSnackbar();
      }
      return null;
    }
  }
}