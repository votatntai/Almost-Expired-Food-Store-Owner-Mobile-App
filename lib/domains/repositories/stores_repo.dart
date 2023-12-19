import 'dart:io';

import 'package:appetit/domains/models/stores.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class StoresRepo {
  final Dio apiClient = getIt<Dio>();
  static Store store = Store();
  Future<Stores> getStoresByOwner() async {
    try {
      var res = await apiClient.get('/api/stores/store-owner');
      return Stores.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createStore(String name, File thumbnail, String description) async {
    try {
      apiClient.options.headers['Content-Type'] = 'multipart/form-data';
      FormData formData = FormData.fromMap({'name': name, 'thumbnail': await MultipartFile.fromFile(thumbnail.path, filename: '${name}_store_thumbnail'), 'description': description});
      var res = await apiClient.post('/api/stores', data: formData);
      return res.statusCode!;
    } on DioException catch (e) {
      print(e);
      throw Exception(msg_server_error);
    }
  }
}
