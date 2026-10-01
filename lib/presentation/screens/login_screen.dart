import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/auth_screen_header.dart';
import 'package:connectme_app/presentation/widgets/custom_text_form_field.dart';
import 'package:connectme_app/presentation/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/widgets/sign_up_section.dart';
import 'package:connectme_app/presentation/widgets/social_auth_buttons.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
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
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'Password',
                      controller: passwordController,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {},
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
                    CustomGradientButton(text: 'LOG IN', onTap: () {}),
                    const SizedBox(height: 40),
                    SocialAuthButtons(onGoogleTap: () {}, onFacebookTap: () {}),
                    const SizedBox(height: 40),
                    SignUpSection(onSignUpTap: () {}),
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
