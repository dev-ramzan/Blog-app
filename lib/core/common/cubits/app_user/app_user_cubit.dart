import 'package:bloc/bloc.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';
part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLogggedIn(user));
    }
  }
}
