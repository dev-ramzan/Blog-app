import 'dart:io';
import 'package:clean_architecture_app/core/error/exception.dart';
import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/network/internet_checker.dart';
import 'package:clean_architecture_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:clean_architecture_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:clean_architecture_app/features/blog/data/models/blog_model.dart';
import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_app/features/blog/domain/repositories/blog_repositry.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImp implements BlogRepositry {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final InternetChecker internetChecker;
  BlogRepositoryImp(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.internetChecker);
  @override
  Future<Either<Failures, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics,
      required}) async {
    try {
      if (!await (internetChecker.isConnected)) {
        return left(Failures("No internet connection!"));
      }
      BlogModel blogModel = BlogModel(
          id: Uuid().v1(),
          posterId: posterId,
          title: title,
          content: content,
          imageUrl: " ",
          topics: topics,
          updateAt: DateTime.now());
      final imageUrl =
          await blogRemoteDataSource.uploadImage(image: image, blog: blogModel);
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedeBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedeBlog);
    } on ServerException catch (e) {
      return left((Failures(e.message)));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (internetChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
