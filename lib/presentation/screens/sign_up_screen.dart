import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/core/widgets/custom_app_dialog.dart';
import 'package:connectme_app/injection.dart';
import 'package:connectme_app/presentation/blocs/auth_cubit.dart';
import 'package:connectme_app/presentation/screens/home_screen.dart';
import 'package:connectme_app/presentation/widgets/auth_screen_header.dart';
import 'package:connectme_app/presentation/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/widgets/custom_text_form_field.dart';
import 'package:connectme_app/presentation/widgets/login_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                      children: [
                        CustomTextFormField(
                          hintText: 'Name',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            String trimmedName = value.trim();
                            String firstLetter = trimmedName[0];
                            if (!RegExp(r'^[A-Z]').hasMatch(firstLetter)) {
                              return 'First letter must be a capital letter (A-Z)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hintText: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hintText: 'Confirm Password',
                          controller: confirmPasswordController,
                          isPassword: true,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is SignUpFailure) {
                              CustomAppDialog.showError(
                                context: context,
                                title: "Error",
                                description: state.failure.errorMessage,
                              );
                            } else if (state is SignUpSuccess) {
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
                            if (state is SignUpLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            } else {
                              return CustomGradientButton(
                                text: 'SIGN UP',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .signupUser(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text,
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
                        LoginSection(
                          onSignInTap: () {
                            Navigator.pop(context);
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
