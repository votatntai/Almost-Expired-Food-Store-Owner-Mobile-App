import 'package:appetit/domains/models/branchs.dart';

class BranchsState {}

class BranchsInitialState extends BranchsState {}

class BranchsLoadingState extends BranchsState {}

class BranchsFailedState extends BranchsState {
  final String msg;
  BranchsFailedState({required this.msg});
}

class BranchsSuccessState extends BranchsState {
  final Branchs branchs;
  BranchsSuccessState({required this.branchs});
}

//Create branch
class CreateBranchState {}

class CreateBranchLoadingState extends CreateBranchState {}

class CreateBranchFailedState extends CreateBranchState {
  final String msg;
  CreateBranchFailedState({required this.msg});
}

class CreateBranchSuccessState extends CreateBranchState {
  final int statusCode;
  CreateBranchSuccessState({required this.statusCode});
}
