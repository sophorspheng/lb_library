
import 'package:dio/dio.dart';

class NetworkAPI {
  NetworkAPI._internal();

  static final NetworkAPI instance = NetworkAPI._internal();

  static const String _baseUrl = 'http://localhost:8080/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Dio get dio => _dio;

  String getBaseUrl() => _baseUrl;

  Future<dynamic> apiGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> apiPost(
    String url,
    dynamic data, {
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> apiPut(String url, dynamic data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> apiPatch(String url, dynamic data) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> apiDelete(
    String url, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> apiGetParamToken(
    String url,
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    return apiGet(
      url,
      queryParameters: data,
      cancelToken: cancelToken,
    );
  }

  Future<dynamic> apiPostParamToken(
    String url,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        url,
        queryParameters: data,
      );
      return response.data;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<List<int>> apiGetExport(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return response.data ?? <int>[];
    } catch (e) {
      _handleError(e);
    }
  }

  Never _handleError(Object error) {
    if (error is DioException) {
      throw NetworkException.fromDio(error);
    }

    throw error;
  }
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({
    required this.message,
    this.statusCode,
  });

  factory NetworkException.fromDio(DioException error) {
    final responseData = error.response?.data;

    String message = error.message ?? 'Something went wrong';

    if (responseData is Map) {
      message = (responseData['message'] ??
              responseData['error'] ??
              message)
          .toString();
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      message = 'Unable to connect to the server';
    }

    return NetworkException(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }

  @override
  String toString() => message;
}
