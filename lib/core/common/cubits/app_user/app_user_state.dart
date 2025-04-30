part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLogggedIn extends AppUserState {
  final User user;

  AppUserLogggedIn(this.user);
}
