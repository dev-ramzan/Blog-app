import 'package:clean_architecture_app/core/common/widgets/loader.dart';
import 'package:clean_architecture_app/core/theme/app_pallete.dart';
import 'package:clean_architecture_app/core/utlis/show_snackebar.dart';
import 'package:clean_architecture_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_architecture_app/features/auth/presentation/pages/login_page.dart';
import 'package:clean_architecture_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:clean_architecture_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
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
                    const Loader();
                  }

                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign up.",
                          style: TextStyle(
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        AuthField(hintText: "Name", controller: nameController),
                        SizedBox(
                          height: 15,
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
                              context.read<AuthBloc>().add(AuthSignUp(
                                  email: emailController.text.trim(),
                                  name: nameController.text.trim(),
                                  passwords: passwordController.text.trim()));
                            }
                          },
                          text: "Sign up",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          },
                          child: RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                      text: "Sign In",
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
