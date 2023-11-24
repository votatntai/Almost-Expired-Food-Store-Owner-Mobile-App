import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

final apiClient = Dio()..options.baseUrl = API_URL..options.headers = {
  // 'Content-Type': 'application/json',
  'Content-Type': 'application/json',
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