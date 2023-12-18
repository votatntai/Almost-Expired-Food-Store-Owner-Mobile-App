import 'package:appetit/domains/models/wallet.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class WalletRepo {
  final Dio _apiClient = getIt<Dio>();

  Future<Wallet> getWallet({required String storeId}) async {
    try {
      var res = await _apiClient.get('/api/wallets/stores/$storeId');
      return Wallet.fromJson(res.data);
    } on DioException catch (e) {
      print('Exception at get wallet: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateWallet({required String walletId, String? bankName, String? backAccount}) async {
    try {
      var res = await _apiClient.put('/api/wallets/$walletId', data: {'bankName' : bankName, 'bankAccount' : backAccount});
      return res.statusCode!;
    } on DioException catch (e) {
      print('Exception at update wallet: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }

  Future<int> withdrawRequest({required int amount}) async {
    try {
      var res = await _apiClient.post('/api/withdraw-requests', data: {'amount' : amount});
      return res.statusCode!;
    }on DioException catch (e) {
      print('Exception at withdraw request: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }
}