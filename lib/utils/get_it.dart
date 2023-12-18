import 'package:appetit/cubits/profile/account_cubit.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/domains/repositories/account_repo.dart';
import 'package:appetit/domains/repositories/branch_repo.dart';
import 'package:appetit/domains/repositories/campaign_repo.dart';
import 'package:appetit/domains/repositories/categories_repo.dart';
import 'package:appetit/domains/repositories/notification_repo.dart';
import 'package:appetit/domains/repositories/orders_repo.dart';
import 'package:appetit/domains/repositories/products_repo.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/domains/repositories/user_repo.dart';
import 'package:appetit/domains/repositories/wallet_repo.dart';
import 'package:appetit/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;

Future<void> initialGetIt() async {
  getIt.registerLazySingleton<Dio>(() => apiClient);

  getIt.registerLazySingleton(() => UserRepo());
  getIt.registerLazySingleton(() => CampaignRepo());
  getIt.registerLazySingleton(() => BranchRepo());
  getIt.registerLazySingleton(() => StoresRepo());
  getIt.registerLazySingleton(() => AccountRepo());
  getIt.registerLazySingleton(() => ProductsRepo());
  getIt.registerLazySingleton(() => CategoriesRepo());
  getIt.registerLazySingleton(() => OrdersRepo());
  getIt.registerLazySingleton(() => NotificationRepo());
  getIt.registerLazySingleton(() => WalletRepo());

  getIt.registerLazySingleton(() => AccountCubit());
  getIt.registerLazySingleton(() => StoresCubit());
}