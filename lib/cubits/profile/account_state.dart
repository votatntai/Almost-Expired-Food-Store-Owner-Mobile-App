
import '../../domains/models/account.dart';

class AccountState {
  
}

class AccountLoadingState extends AccountState {
  
}

class AccountFailedState extends AccountState {
  final String message;

  AccountFailedState({required this.message});
}

class AccountSuccessState extends AccountState {
  final Account account;

  AccountSuccessState({required this.account});
}