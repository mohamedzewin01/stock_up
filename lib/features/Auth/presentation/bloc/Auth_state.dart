part of 'Auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final LoginEntity? loginEntity;

  AuthSuccess(this.loginEntity);
}

final class AuthFailure extends AuthState {
  final Exception exception;

  AuthFailure(this.exception);
}
