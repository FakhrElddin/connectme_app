import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/core/widgets/custom_app_dialog.dart';
import 'package:connectme_app/injection.dart';
import 'package:connectme_app/presentation/blocs/auth_cubit.dart';
import 'package:connectme_app/presentation/screens/home_screen.dart';
import 'package:connectme_app/presentation/screens/sign_up_screen.dart';
import 'package:connectme_app/presentation/widgets/auth_screen_header.dart';
import 'package:connectme_app/presentation/widgets/custom_text_form_field.dart';
import 'package:connectme_app/presentation/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/widgets/sign_up_section.dart';
import 'package:connectme_app/presentation/widgets/social_auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        body: Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Stack(
              children: [
                const AuthScreenHeader(),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.335),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                          hintText: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Email must contain @';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hintText: 'Password',
                          controller: passwordController,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {},
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'FORGOT PASSWORD',
                            style: TextStyle(
                              fontFamily: 'CircularStd',
                              fontSize: 14,
                              color: AppColors.primaryColor,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is LoginFailure) {
                              CustomAppDialog.showError(
                                context: context,
                                title: "Error",
                                description: state.failure.errorMessage,
                              );
                            } else if (state is LoginSuccess) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            } else {
                              return CustomGradientButton(
                                text: 'LOG IN',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .loginUser(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                  } else {
                                    autoValidateMode = AutovalidateMode.always;
                                    setState(() {});
                                  }
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        SocialAuthButtons(
                          onGoogleTap: () {},
                          onFacebookTap: () {},
                        ),
                        const SizedBox(height: 40),
                        SignUpSection(
                          onSignUpTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
