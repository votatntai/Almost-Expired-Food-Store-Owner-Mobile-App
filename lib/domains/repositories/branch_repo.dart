import 'package:appetit/domains/models/branchs.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';

class BranchRepo {
  final Dio _apiClient = getIt.get<Dio>();
  
  Future<Branchs> getBranchsOfOwner() async {
    try {
      var res = await _apiClient.get('/api/branchs/store-owner');
      return Branchs.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createBranch(String address, double lat, double lng, String phone) async {
    try {
      var res = await _apiClient.post('/api/branchs', data: {'address' : address, 'latitude' : lat, 'longitude' : lng, 'phone' : phone});
      return res.statusCode!;
    } on DioException catch (e){
      print(e);
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateBranch({required String branchId, String? address, String? phone, double? latitude, double? longitude}) async {
    try {
      var res = await _apiClient.put('/api/branchs/$branchId', data: {'address' : address, 'phone' : phone, 'latitude' : latitude, 'longitude' : longitude});
      return res.statusCode!;
    } on DioException catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
