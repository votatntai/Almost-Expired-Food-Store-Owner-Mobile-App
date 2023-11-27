import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/orders.dart';

class OrdersRepo {
  final Dio _apiClient = getIt.get<Dio>();

  Future<Orders> getOrdersList({required String storeId, String? status, bool? isPayment}) async {
    try {
      var res = await _apiClient.get('/api/orders/store/$storeId', queryParameters: {'status' : status, 'isPayment' : isPayment});
      return Orders.fromJson(res.data);
    } on DioException catch (e){
      print(e);
      throw Exception(msg_server_error);
    }
  }
}