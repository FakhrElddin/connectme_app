import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/auth_screen_header.dart';
import 'package:connectme_app/presentation/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/widgets/custom_text_form_field.dart';
import 'package:connectme_app/presentation/widgets/login_section.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
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
                    ),
                    const SizedBox(height: 40),
                    CustomGradientButton(text: 'SIGN IN', onTap: () {}),
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
    );
  }
}
