import 'package:appetit/domains/models/branchs.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';

class BranchRepo {
  final Dio apiClient = getIt.get<Dio>();
  
  Future<Branchs> getBranchsOfOwner() async {
    try {
      var res = await apiClient.get('/api/branchs/store-owner');
      return Branchs.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createBranch(String address, double lat, double lng, String phone) async {
    try {
      var res = await apiClient.post('/api/branchs', data: {'address' : address, 'latitude' : lat, 'longitude' : lng, 'phone' : phone});
      return res.statusCode!;
    } on DioException catch (e){
      print(e);
      throw Exception(msg_server_error);
    }
  }
}