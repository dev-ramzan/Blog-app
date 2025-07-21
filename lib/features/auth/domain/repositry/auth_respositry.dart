import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRespositry {
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failures, User>> CurrentUser();
}
