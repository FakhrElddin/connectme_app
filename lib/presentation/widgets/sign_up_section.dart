import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpSection extends StatelessWidget {
  const SignUpSection({super.key, this.onSignUpTap});

  final VoidCallback? onSignUpTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Don't have account? ",
        style: const TextStyle(
          fontFamily: 'CircularStd',
          fontSize: 16,
          color: AppColors.darkGreyColor,
          letterSpacing: -0.2,
        ),
        children: [
          TextSpan(
            text: 'SIGN UP',
            style: const TextStyle(
              fontFamily: 'CircularStd',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
              letterSpacing: -0.2,
            ),
            recognizer: TapGestureRecognizer()..onTap = onSignUpTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
