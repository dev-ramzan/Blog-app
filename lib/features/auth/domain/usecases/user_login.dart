import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/repositry/auth_respositry.dart';
import 'package:fpdart/src/either.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRespositry authRespositry;

  UserLogin(this.authRespositry);
  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async {
    return await authRespositry.loginWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
