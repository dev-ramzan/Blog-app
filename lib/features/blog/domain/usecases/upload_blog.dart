import 'dart:io';

import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_app/features/blog/domain/repositories/blog_repositry.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepositry blogRepositry;

  UploadBlog(this.blogRepositry);
  @override
  Future<Either<Failures, Blog>> call(UploadBlogParams params) async {
    return await blogRepositry.uploadBlog(
        image: params.image,
        title: params.title,
        content: params.content,
        posterId: params.posterId,
        topics: params.topics);
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams(
      {required this.posterId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}
