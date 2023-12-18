import 'package:appetit/cubits/wallet/wallet_state.dart';
import 'package:appetit/domains/repositories/wallet_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

final WalletRepo _walletRepo = getIt<WalletRepo>();

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({required String storeId}) : super(WalletState()){getWallet(storeId: storeId);}
  Future<void> getWallet({required String storeId}) async {
    try {
      emit(WalletLoadingState());
      var wallet = await _walletRepo.getWallet(storeId: storeId);
      emit(WalletSuccessState(wallet: wallet));
    } on Exception catch (e) {
      emit(WalletFailedState(msg: e.toString()));
    }
  }
}

//Update wallet
class UpdateWalletCubit extends Cubit<UpdateWalletState> {
  UpdateWalletCubit() : super(UpdateWalletState());
  Future<void> updateWallet({required String walletId, String? bankName, String? bankAccount}) async {
    try {
      emit(UpdateWalletLoadingState());
      var statusCode = await _walletRepo.updateWallet(walletId: walletId, bankName: bankName, backAccount: bankAccount);
      emit(UpdateWalletSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(UpdateWalletFailedState(msg: e.toString()));
    }
  }
}

//Withdraw request
class WithdrawRequestCubit extends Cubit<WithdrawRequestState> {
  WithdrawRequestCubit() : super(WithdrawRequestState());
  Future<void> withdrawRequest({required int amount}) async {
    try {
      emit(WithdrawRequestLoadingState());
      var statusCode = await _walletRepo.withdrawRequest(amount: amount);
      emit(WithdrawRequestSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(WithdrawRequestFailedState(msg: e.toString()));
    }
  }
}
