import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/account.dart';

class AccountRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Account> getAccountInformation() async {
    try {
      var res = await apiClient.get('/store-owners/information');
      return Account.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }
}