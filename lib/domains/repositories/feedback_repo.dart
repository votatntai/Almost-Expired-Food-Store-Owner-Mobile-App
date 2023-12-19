import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/feedback.dart';

class FeedbackRepo {
  final Dio _apiClient = getIt.get<Dio>();

  Future<int> feedback({required int star, String? message, required String productId}) async {
    try {
      var res = await _apiClient.post('/api/feedbacks', data: {'star' : star, 'message' : message, 'productId' : productId});
      return res.statusCode!;
    } on DioException catch (e) {
      print('Exception at feedback: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }

  Future<Feedback> getFeedback({required String productId, String? customerId}) async {
    try {
      var res = await _apiClient.get('/api/feedbacks', queryParameters: {'customerId' : customerId, 'productId' : productId});
      return Feedback.fromJson(res.data);
    } on DioException catch (e) {
      print('Exception at get feedback: ' + e.response!.data);
      throw Exception(msg_server_error);
    }
  }
}