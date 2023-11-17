import 'package:appetit/cubits/login/login_state.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../domains/repositories/user_repo.dart';
import '../../services/auth_service.dart';

class LoginByGoogleCubit extends Cubit<LoginByGoogleState> {
  final UserRepo _userRepo = getIt<UserRepo>();

  LoginByGoogleCubit() : super (LoginByGoogleState());

  Future<void> loginByGoole() async{

    try {
      emit(LoginByGooglelLoadingState());
      final idToken = await AuthService().signInWithGoogle(); 
      await _userRepo.login(idToken: idToken);
      emit(LoginByGooglelSuccessState());
    } on Exception catch (e) {
      emit(LoginByGooglelFailedState(message: e.toString()));
    }
  }
}