import 'package:appetit/cubits/branch/branchs_state.dart';
import 'package:appetit/domains/repositories/branch_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchsCubit extends Cubit<BranchsState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  BranchsCubit() : super(BranchsInitialState());

  Future<void> getBranchsOfOwner() async {
    try {
      emit(BranchsLoadingState());
      final branchs = await _branchRepo.getBranchsOfOwner();
      emit(BranchsSuccessState(branchs: branchs));
    } on Exception catch (e) {
      emit(BranchsFailedState(msg: e.toString()));
    }
  }

  void refresh() {
    emit(BranchsLoadingState());
    getBranchsOfOwner();
  }
}

//Create branch
class CreateBranchCubit extends Cubit<CreateBranchState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  CreateBranchCubit() : super(CreateBranchState());

  Future<void> createBranch(String address, double lat, double lng, String phone) async {
    try {
      emit(CreateBranchLoadingState());
      final statusCode = await _branchRepo.createBranch(address, lat, lng, phone);
      emit(CreateBranchSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(CreateBranchFailedState(msg: e.toString()));
    }
  }
}

//Create branch
class UpdateBranchCubit extends Cubit<UpdateBranchState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  UpdateBranchCubit() : super(UpdateBranchState());

  Future<void> updateBranch({required String branchId, String? address, double? lat, double? lng, String? phone}) async {
    try {
      emit(UpdateBranchLoadingState());
      final statusCode = await _branchRepo.updateBranch(branchId: branchId, address: address, latitude: lat, longitude: lng, phone: phone);
      emit(UpdateBranchSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(UpdateBranchFailedState(msg: e.toString()));
    }
  }
}
