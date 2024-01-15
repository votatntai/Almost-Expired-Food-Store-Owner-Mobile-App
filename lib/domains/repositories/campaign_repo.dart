import 'package:appetit/domains/models/campaign/updateCampaign.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../models/campaign/campaigns.dart';
import '../models/campaign/createCampaign.dart';

class CampaignRepo {
  final Dio apiClient = getIt.get<Dio>();
  Future<Campaigns> getCampaignsList(String? storeOwnerId, String? branchId,
      String? storeId, String? name) async {
    try {
      var res = await apiClient.get('/api/campaigns', queryParameters: {
        'storeOwnerId': storeOwnerId,
        'branchId': branchId,
        'storeId': storeId,
        'name': name
      });
      return Campaigns.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createCampaign({required CreateCampaign campaign}) async {
    try {
      FormData formData = FormData.fromMap({
        'branchId': campaign.branchId,
        'name': campaign.name,
        'thumbnail': await MultipartFile.fromFile(
          campaign.thumbnail!.path,
          filename: '${campaign.name}_campaign_thumbnail',
        ),
        'startTime': campaign.startTime,
        'endTime': campaign.endTime
      });
      // apiClient.options.headers['Content-Type'] = 'multipart/form-data';
      var res = await apiClient.post(
        '/api/campaigns',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // Bạn có thể thêm các header khác nếu cần
          },
        ),
      );
      return res.statusCode!;
    } on DioException catch (e) {
      print(e.response);
      if (e.response!.statusCode == 409) {
        throw Exception(msg_create_campaign_duplicated);
      }
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateCampaign(
      {required String campaignId, required UpdateCampaign campaign}) async {
    try {
      var res = await apiClient.put('/api/campaigns/$campaignId', data: {
        'startTime': campaign.startTime,
        'endTime': campaign.endTime,
        'name': campaign.name,
        'status': campaign.status
      });
      return res.statusCode!;
    } on DioException catch (e) {
      print(e);
      throw Exception(e.response!.data);
    }
  }

  Future<int> deleteCampaign({required String campaignId}) async {
    try {
      var res = await apiClient.delete('/api/campaigns/$campaignId');
      return res.statusCode!;
    } on DioException catch (e) {
      print(e);
      throw Exception(e.response!.data);
    }
  }
}
