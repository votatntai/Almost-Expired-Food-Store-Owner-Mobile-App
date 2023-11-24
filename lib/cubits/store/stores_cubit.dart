import 'dart:io';

import 'package:appetit/cubits/store/stores_state.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepo _storesRepo = getIt<StoresRepo>();
  StoresCubit() :super(StoresState());

  Future<void> getStoresByOwner() async {
    try {
      emit(StoresLoadingState());
      var stores = await _storesRepo.getStoresByOwner();
      emit(StoresSuccessState(stores: stores));
    } on Exception catch (e) {
      emit(StoresFailedState(msg: e.toString()));
    }
  }
}

//Create store
class CreateStoreCubit extends Cubit<CreateStoreState> {
  final StoresRepo _storesRepo = getIt<StoresRepo>();
  CreateStoreCubit() : super(CreateStoreState());

   Future<void> createStore(String name, File thumbnail, String description) async {
    try {
      emit(CreateStoreLoadingState());
      var statusCode = await _storesRepo.createStore(name, thumbnail, description);
      emit(CreateStoreSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(CreateStoreFailedState(msg: e.toString()));
    }
  }
}