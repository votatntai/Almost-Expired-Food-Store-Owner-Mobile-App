import '../../domains/models/account.dart';

class AccountState {}

class AccountLoadingState extends AccountState {}

class AccountFailedState extends AccountState {
  final String message;

  AccountFailedState({required this.message});
}

class AccountSuccessState extends AccountState {
  final Account account;

  AccountSuccessState({required this.account});
}

//Update profile
class UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileFailedState extends UpdateProfileState {
  final String msg;
  UpdateProfileFailedState({required this.msg});
}

class UpdateProfileSuccessState extends UpdateProfileState {
  final int statusCode;
  UpdateProfileSuccessState({required this.statusCode});
}
