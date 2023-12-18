import 'package:appetit/domains/models/wallet.dart';

class WalletState {}

class WalletLoadingState extends WalletState {}

class WalletFailedState extends WalletState {
  final String msg;
  WalletFailedState({required this.msg});
}

class WalletSuccessState extends WalletState {
  final Wallet wallet;
  WalletSuccessState({required this.wallet});
}

//Update wallet
class UpdateWalletState {}

class UpdateWalletLoadingState extends UpdateWalletState {}

class UpdateWalletFailedState extends UpdateWalletState {
  final String msg;
  UpdateWalletFailedState({required this.msg});
}

class UpdateWalletSuccessState extends UpdateWalletState {
  final int statusCode;
  UpdateWalletSuccessState({required this.statusCode});
}

//Withdraw request
class WithdrawRequestState {}

class WithdrawRequestLoadingState extends WithdrawRequestState {}

class WithdrawRequestFailedState extends WithdrawRequestState {
  final String msg;
  WithdrawRequestFailedState({required this.msg});
}

class WithdrawRequestSuccessState extends WithdrawRequestState {
  final int statusCode;
  WithdrawRequestSuccessState({required this.statusCode});
}
