import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/categories.dart';

class CategoriesRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Categories> getCategories(
      String? categoryGroupId, String? campaignId, String? name) async {
    try {
      var res = await apiClient.get('/api/categories', queryParameters: {
        'categoryGroupId': categoryGroupId,
        'campaignId': campaignId,
        'name': name
      });
      return Categories.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  // Future<Categories> getCategoriesByCampaignId(String campaignId) async {
  //   try {
  //     var res = await apiClient.get('/api/categories', queryParameters: {'campaignId' : campaignId});
  //     return Categories.fromJson(res.data);
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }

  // Future<Categories> searchCategory(String name) async {
  //   try {
  //     var res = await apiClient.get('/api/categories?name=$name', data: {});
  //     return Categories.fromJson(res.data);
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }
}
