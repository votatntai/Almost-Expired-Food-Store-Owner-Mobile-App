import 'package:appetit/cubits/branch/branchs_state.dart';
import 'package:appetit/domains/repositories/branch_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchsCubit extends Cubit<BranchsState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  BranchsCubit() :super(BranchsInitialState());

  Future<void> getBranchsOfOwner() async {
    try {
      emit(BranchsLoadingState());
      final branchs = await _branchRepo.getBranchsOfOwner();
      emit(BranchsSuccessState(branchs: branchs));
    } on Exception catch (e) {
      emit(BranchsFailedState(msg: e.toString()));
    }
  }
}

//Create branch
class CreateBranchCubit extends Cubit<CreateBranchState> {
  final BranchRepo _branchRepo = getIt<BranchRepo>();
  CreateBranchCubit():super(CreateBranchState());

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