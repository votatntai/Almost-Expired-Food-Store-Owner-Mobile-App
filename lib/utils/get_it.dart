import 'package:appetit/domains/repositories/branch_repo.dart';
import 'package:appetit/domains/repositories/campaign_repo.dart';
import 'package:appetit/domains/repositories/user_repo.dart';
import 'package:appetit/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);
  // getIt.registerLazySingleton<Dio>(() => apiClientMuilipart);

  getIt.registerLazySingleton(() => UserRepo());
  getIt.registerLazySingleton(() => CampaignRepo());
  getIt.registerLazySingleton(() => BranchRepo());
}