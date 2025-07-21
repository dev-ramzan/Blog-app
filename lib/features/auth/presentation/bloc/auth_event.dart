part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String passwords;
  AuthSignUp(
      {required this.email, required this.name, required this.passwords});
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String passwords;
  AuthLogin({required this.email, required this.passwords});
}

final class AuthIsUserLoggedIn extends AuthEvent {}
