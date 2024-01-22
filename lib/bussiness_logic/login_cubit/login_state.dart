part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class AppInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class UserNotExist extends LoginState {
  final String message;

  UserNotExist(this.message);
}
class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}


