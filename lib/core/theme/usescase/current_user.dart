import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_app/features/auth/domain/repositry/auth_respositry.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRespositry authRespositry;

  CurrentUser(this.authRespositry);
  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRespositry.CurrentUser();
  }
}
