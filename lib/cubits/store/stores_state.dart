import 'package:appetit/domains/models/stores.dart';

class StoresState {}

class StoresLoadingState extends StoresState {}

class StoresFailedState extends StoresState {
  final String msg;
  StoresFailedState({required this.msg});
}

class StoresSuccessState extends StoresState {
  final Stores stores;
  StoresSuccessState({required this.stores});
}

//Create Store
class CreateStoreState {}

class CreateStoreLoadingState extends CreateStoreState {}

class CreateStoreFailedState extends CreateStoreState {
  final String msg;
  CreateStoreFailedState({required this.msg});
}

class CreateStoreSuccessState extends CreateStoreState {
  final int statusCode;
  CreateStoreSuccessState({required this.statusCode});
}

//Update Store
class UpdateStoreState {}

class UpdateStoreLoadingState extends UpdateStoreState {}

class UpdateStoreFailedState extends UpdateStoreState {
  final String msg;
  UpdateStoreFailedState({required this.msg});
}

class UpdateStoreSuccessState extends UpdateStoreState {
  final int statusCode;
  UpdateStoreSuccessState({required this.statusCode});
}
