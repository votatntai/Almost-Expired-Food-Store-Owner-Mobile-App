import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../domains/models/account.dart';
import '../../domains/repositories/account_repo.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepo _accountRepo = getIt<AccountRepo>();
  AccountCubit() : super(AccountState()){
    getAccountProfile();
  }

  Future<void> getAccountProfile() async {
    try {
      emit(AccountLoadingState());
      Account account = await _accountRepo.getAccountInformation();
      emit(AccountSuccessState(account: account));
    } catch (e) {
      emit(AccountFailedState(message: e.toString()));
    }
  }
}