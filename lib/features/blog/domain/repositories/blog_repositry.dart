import 'dart:io';

import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepositry {
  Future<Either<Failures, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics,
      required});
  Future<Either<Failures, List<Blog>>> getAllBlogs();
}
