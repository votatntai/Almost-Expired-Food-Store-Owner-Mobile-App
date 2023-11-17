import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

final apiClient = Dio()..options.baseUrl = API_URL..options.headers = {
  // 'Content-Type': 'application/json',
  'Content-Type': 'multipart/form-data',
    'Accept': '*/*',
}..interceptors.addAll([
  InterceptorsWrapper(
    onRequest: (request, handler) async {
      var token = getStringAsync(TOKEN_KEY);
      if (token.isNotEmpty) {
        request.headers['Authorization'] = token;
      }
      return handler.next(request);
    }
  )
]);

final apiClientMuilipart = Dio()..options.baseUrl = API_URL..options.headers = {
  'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
}..interceptors.addAll([
  InterceptorsWrapper(
    onRequest: (request, handler) async {
      var token = getStringAsync(TOKEN_KEY);
      if (token.isNotEmpty) {
        request.headers['Authorization'] = token;
      }
      return handler.next(request);
    },
  )
]);