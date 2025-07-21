import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';

import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_app/features/blog/domain/repositories/blog_repositry.dart';
import 'package:fpdart/src/either.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepositry blogRepositry;

  GetAllBlogs(this.blogRepositry);

  @override
  Future<Either<Failures, List<Blog>>> call(NoParams params) async {
    return await blogRepositry.getAllBlogs();
  }
}
