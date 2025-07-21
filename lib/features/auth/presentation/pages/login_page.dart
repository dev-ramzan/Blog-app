import 'package:clean_architecture_app/core/common/widgets/loader.dart';
import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_app/core/utlis/show_snackebar.dart';
import 'package:clean_architecture_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_app/features/auth/presentation/pages/signup_page.dart';
import 'package:clean_architecture_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:clean_architecture_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ShowSnackbar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Loader();
                  }
                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log In.",
                          style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        AuthField(
                          hintText: "Email",
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        AuthField(
                          hintText: "Passwords",
                          isObscure: true,
                          controller: passwordController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AuthGradientButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthLogin(
                                  email: emailController.text.trim(),
                                  passwords: passwordController.text.trim()));
                            }
                          },
                          text: "Log in",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ));
                          },
                          child: RichText(
                            text: TextSpan(
                                text: "Don't have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                      text: "Sign Up",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color: AppPallete.gradient2,
                                              fontWeight: FontWeight.bold))
                                ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
