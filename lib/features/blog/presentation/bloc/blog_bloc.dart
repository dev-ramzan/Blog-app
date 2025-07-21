import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_app/core/theme/usescase/usecase.dart';
import 'package:clean_architecture_app/features/blog/domain/entities/blog.dart';
import 'package:clean_architecture_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_architecture_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:meta/meta.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogUploadEvent>(_onUploadBlogEvent);
    on<getAllBlogsEvent>(_onGetAllBlogEvent);
  }

  void _onGetAllBlogEvent(
      getAllBlogsEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _getAllBlogs(NoParams());
    return res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }

  void _onUploadBlogEvent(
      BlogUploadEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    return res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }
}
