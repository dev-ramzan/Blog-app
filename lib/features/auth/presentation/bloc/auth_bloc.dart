import 'package:clean_architecture_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_app/core/theme/usescase/current_user.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/usecases/user_login.dart';
import 'package:clean_architecture_app/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit; //,,,,,,,,,,,,,,,
  AuthBloc({
    required UserSignup userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit, //......................
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }
  //#################################################
  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());
    res.fold(
        (l) => emit(AuthFailure(l.message)), (r) => _emitAuthSuccess(r, emit));
  }

//###############################################
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignup(UserSignupParam(
        email: event.email, name: event.name, passwords: event.passwords));
    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  // #############################################
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.passwords));
    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

//##########################################################
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
