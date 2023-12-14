import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/account.dart';

class AccountRepo {
  final Dio _apiClient = getIt.get<Dio>();

  Future<Account> getAccountInformation() async {
    try {
      var res = await _apiClient.get('/api/store-owners/information');
      return Account.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateProfile({String? name, String? phone}) async {
    try {
      var res = await _apiClient.put('/api/store-owners', data: {'name': name, 'phone' : phone});
      return res.statusCode!;
    } on DioException catch (e) {
      print('Exception at Update Profile: ' + e.response!.data.toString());
      throw Exception(msg_server_error);
    }
  }
}