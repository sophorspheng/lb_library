
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Default request headers.
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    // Add authentication when your backend supports it.
    // options.headers['Authorization'] = 'Bearer $accessToken';

    if (kDebugMode) {
      debugPrint(
        '[API REQUEST] ${options.method} ${options.uri}',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[API RESPONSE] ${response.statusCode} '
        '${response.requestOptions.uri}',
      );
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[API ERROR] ${err.requestOptions.uri}: '
        '${err.message}',
      );
    }

    handler.next(err);
  }
}
