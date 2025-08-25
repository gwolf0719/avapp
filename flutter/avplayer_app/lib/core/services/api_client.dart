import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('連線逾時，請稍後再試');
      case DioExceptionType.badResponse:
        return ApiException(_parseErrorMessage(error.response));
      case DioExceptionType.cancel:
        return ApiException('請求已取消');
      case DioExceptionType.connectionError:
        return ApiException('無法連接到伺服器，請檢查網路連線');
      case DioExceptionType.unknown:
        return ApiException('未知錯誤：${error.message}');
      case DioExceptionType.badCertificate:
        return ApiException('憑證錯誤');
    }
  }

  String _parseErrorMessage(Response? response) {
    if (response?.data is Map) {
      final data = response!.data as Map<String, dynamic>;
      return data['detail'] ?? data['error'] ?? '伺服器錯誤';
    }
    return '伺服器回應錯誤 (${response?.statusCode})';
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
