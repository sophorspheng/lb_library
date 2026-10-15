
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:lb_library/core/network/network_api.dart';

class HelperNotifier extends ChangeNotifier {
  HelperNotifier._internal();

  static final HelperNotifier _instance =
      HelperNotifier._internal();

  factory HelperNotifier() => _instance;

  static final NetworkAPI _request = NetworkAPI.instance;

  final Map<String, dynamic> _provider = {};

  // Shared state

  void addProvider(String key, dynamic data) {
    _provider[key] = data;
    notifyListeners();
  }

  T? getProvider<T>(String key) {
    final value = _provider[key];
    return value is T ? value : null;
  }

  void removeProvider(String key) {
    if (_provider.containsKey(key)) {
      _provider.remove(key);
      notifyListeners();
    }
  }

  void clearProviders() {
    _provider.clear();
    notifyListeners();
  }

  // HTTP methods

  static Future<T> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = await _request.apiGet(
      url,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );

    return response as T;
  }

  static Future<T> post<T>({
    required String url,
    required dynamic data,
  }) async {
    final response = await _request.apiPost(url, data);
    return response as T;
  }

  static Future<T> postParam<T>({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    final response = await _request.apiPostParamToken(
      url,
      data,
    );

    return response as T;
  }

  static Future<T> put<T>({
    required String url,
    required dynamic data,
  }) async {
    final response = await _request.apiPut(url, data);
    return response as T;
  }

  static Future<T> delete<T>({
    required String url,
    dynamic data,
  }) async {
    final response = await _request.apiDelete(
      url,
      data: data,
    );

    return response as T;
  }

  // Convert a JSON object into a model.

  static Future<T> getModel<T>({
    required String url,
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await get<dynamic>(
      url: url,
      queryParameters: queryParameters,
    );

    return fromJson(response);
  }

  // Convert a JSON array into a list of models.

  static Future<List<T>> getList<T>({
    required String url,
    required T Function(dynamic json) fromJson,
    Map<String, dynamic>? queryParameters,
    String? dataField,
  }) async {
    final response = await get<dynamic>(
      url: url,
      queryParameters: queryParameters,
    );

    dynamic data = response;

    if (dataField != null && response is Map) {
      data = response[dataField];
    }

    if (data is! List) {
      throw const FormatException(
        'Expected a list in the API response.',
      );
    }

    return data.map<T>(fromJson).toList();
  }
}
