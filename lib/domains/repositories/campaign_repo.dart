import 'package:appetit/domains/models/CreateCampaign.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

class CampaignRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<int> createCampaign({required CreateCampaign campaign}) async {
    try {
      FormData formData = FormData.fromMap({
        'branchId': campaign.branchId, 'name': campaign.name,
      'thumbnail': await MultipartFile.fromFile(
        campaign.thumbnailUrl!.path,
        filename: '${campaign.name}_thumbnail',
      ),
      'startTime': campaign.startTime, 'endTime': campaign.endTime
    });
      var res = await apiClient.post(
        '/api/campaigns',
        // data: {'branchId': campaign.branchId, 'name': campaign.name, 'thumbnail': await MultipartFile.fromFile(campaign.thumbnailUrl!.path, filename: '${campaign.name}_thumbnail'), 'startTime': campaign.startTime, 'endTime': campaign.endTime},
        data: formData
        // options: Options(
        //   headers: {
        //     'Content-Type': 'multipart/form-data',
        //   },
        // ),
      );
      return res.statusCode!;
    } on DioException catch (e) {
      print(e.response);
      throw Exception(msg_server_error);
    }
  }
}
