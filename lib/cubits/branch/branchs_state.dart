import 'package:appetit/domains/models/Branchs.dart';

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
