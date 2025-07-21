import 'package:clean_architecture_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_app/core/network/internet_checker.dart';
import 'package:clean_architecture_app/core/secrects/app_secrect.dart';
import 'package:clean_architecture_app/core/theme/usescase/current_user.dart';
import 'package:clean_architecture_app/features/auth/data/datasources/auth_remote_data_scources.dart';
import 'package:clean_architecture_app/features/auth/data/repositries/auth_respositry_implement.dart';
import 'package:clean_architecture_app/features/auth/domain/repositry/auth_respositry.dart';
import 'package:clean_architecture_app/features/auth/domain/usecases/user_login.dart';
import 'package:clean_architecture_app/features/auth/domain/usecases/user_signup.dart';
import 'package:clean_architecture_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:clean_architecture_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:clean_architecture_app/features/blog/data/repositories/blog_repository_imp.dart';
import 'package:clean_architecture_app/features/blog/domain/repositories/blog_repositry.dart';
import 'package:clean_architecture_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:clean_architecture_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:clean_architecture_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
      url: AppSecrect.supabaseUrl, anonKey: AppSecrect.supabaseAnonkey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: "blogs"));
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
  //from core folder
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<InternetChecker>(
    () => InternetCheckerImp(serviceLocator()),
  );
}

void _initAuth() {
  // data source
  serviceLocator.registerFactory<AuthRemoteDataScources>(
      () => AuthRemoteDataScourcesImp(serviceLocator()));
  // repositry
  serviceLocator.registerFactory<AuthRespositry>(
      () => AuthRespositryImplement(serviceLocator(), serviceLocator()));
  // usecase
  serviceLocator.registerFactory(() => UserSignup(serviceLocator()));
  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));
  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  //bloc part
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userLogin: serviceLocator(),
      userSignUp: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  // data source
  serviceLocator.registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImp(supabaseClient: serviceLocator()));
  serviceLocator.registerFactory<BlogLocalDataSource>(
    () => BlogLocalDataSourceImp(serviceLocator()),
  );

  //repositry
  serviceLocator.registerFactory<BlogRepositry>(() =>
      BlogRepositoryImp(serviceLocator(), serviceLocator(), serviceLocator()));

  //usecases
  serviceLocator.registerFactory(() => UploadBlog(serviceLocator()));
  serviceLocator.registerFactory(() => GetAllBlogs(serviceLocator()));

  //bloc
  serviceLocator.registerLazySingleton(() =>
      BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()));
}
