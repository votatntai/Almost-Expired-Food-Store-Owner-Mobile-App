class LoginByGoogleState {}

class LoginByGooglelLoadingState extends LoginByGoogleState {}

class LoginByGooglelFailedState extends LoginByGoogleState {
  final String message;

  LoginByGooglelFailedState({required this.message});
}

class LoginByGooglelSuccessState extends LoginByGoogleState {}

class LogoutState {}

class LogoutFailedState extends LogoutState {
  final String msg;
  LogoutFailedState({required this.msg});
}

class LogoutSuccessState extends LogoutState {}
