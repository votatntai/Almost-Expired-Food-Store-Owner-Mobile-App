import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../domains/models/account.dart';
import '../../domains/repositories/account_repo.dart';
import 'account_state.dart';

final AccountRepo _accountRepo = getIt<AccountRepo>();

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountState()) {
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

//Update profile
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileState());

  Future<void> updateProfile({String? name, String? phone}) async {
    try {
      emit(UpdateProfileLoadingState());
      var statusCode = await _accountRepo.updateProfile(name: name, phone: phone);
      emit(UpdateProfileSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(UpdateProfileFailedState(msg: e.toString()));
    }
  }
}
