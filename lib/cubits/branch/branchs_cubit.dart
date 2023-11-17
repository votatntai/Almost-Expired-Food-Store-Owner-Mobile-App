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