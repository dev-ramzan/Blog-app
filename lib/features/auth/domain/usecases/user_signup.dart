import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/repositry/auth_respositry.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements UseCase<User, UserSignupParam> {
  AuthRespositry authRespositry;
  UserSignup(this.authRespositry);
  @override
  Future<Either<Failures, User>> call(UserSignupParam params) async {
    return await authRespositry.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.passwords);
  }
}

class UserSignupParam {
  final String name;
  final String email;
  final String passwords;
  UserSignupParam(
      {required this.email, required this.name, required this.passwords});
}
