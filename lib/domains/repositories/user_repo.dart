import 'package:appetit/utils/Constants.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';

class UserRepo{
  final Dio apiClient = getIt.get<Dio>();
  static String deviceToken = '';
  Future<void> login({required String idToken}) async{
     try {
      var res = await apiClient.post('/api/auth/google/store-owner', data: {'idToken': idToken});
       var accessToken = res.data['accessToken'] as String?;
       if (accessToken == null || accessToken.isEmpty) {
         throw Exception(msg_login_token_invalid);
       }
       await setValue(AppConstant.TOKEN_KEY, accessToken);
     } on DioException catch (e) {
      print(e);
       if (e.response!.statusCode == 401) {
         throw Exception(msg_login_by_google_failed_title);
       }
       if (e.response!.statusCode == 423) {
         throw Exception(msg_account_locked);
       }
       throw Exception(msg_server_error);
     }
  }

  Future<void> sendDeviceToken() async {
    try {
      var res = await apiClient.post('/api/device-tokens/store-owners', data: {'deviceToken' : deviceToken});
      print(res.data);
    } on DioException catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}