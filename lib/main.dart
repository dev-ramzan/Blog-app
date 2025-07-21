import 'package:clean_architecture_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_architecture_app/core/theme/theme.dart';
import 'package:clean_architecture_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_app/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:clean_architecture_app/features/blog/presentation/pages/blog_page.dart';
import 'package:clean_architecture_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BlogBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: BlocListener<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserLogggedIn) {
            setState(() {});
          }
        },
        child: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLogggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return BlogPage();
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}
