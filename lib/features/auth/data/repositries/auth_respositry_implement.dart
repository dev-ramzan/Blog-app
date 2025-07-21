import 'package:clean_architecture_app/core/error/exception.dart';
import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/network/internet_checker.dart';
import 'package:clean_architecture_app/features/auth/data/datasources/auth_remote_data_scources.dart';
import 'package:clean_architecture_app/features/auth/data/models/user_model.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/repositry/auth_respositry.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart ' as sb;

class AuthRespositryImplement implements AuthRespositry {
  final AuthRemoteDataScources remoteDataScources;
  final InternetChecker internetChecker;
  AuthRespositryImplement(this.remoteDataScources, this.internetChecker);

  @override
  Future<Either<Failures, User>> CurrentUser() async {
    try {
      if (!await (internetChecker.isConnected)) {
        final session = remoteDataScources.currentUserSession;
        if (session == null) {
          return left(Failures("user is not logged in"));
        }
        return right(UserModel(
            id: session.user.id, email: session.user.email ?? " ", name: " "));
      }
      final user = await remoteDataScources.getCurrentUserData();
      if (user == null) {
        return left(Failures('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      if (!await (internetChecker.isConnected)) {
        return left(Failures("Internet is not connected"));
      }
      final user = await remoteDataScources.loginWithEmailPasword(
          email: email, password: password);
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      if (!await (internetChecker.isConnected)) {
        return left(Failures("Internet is not connected"));
      }
      final user = await remoteDataScources.signUpWithEmailPasword(
          name: name, email: email, password: password);
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
