import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key, this.onSignInTap});

  final VoidCallback? onSignInTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Already have account? ",
        style: const TextStyle(
          fontFamily: 'CircularStd',
          fontSize: 16,
          color: AppColors.darkGreyColor,
        ),
        children: [
          TextSpan(
            text: 'SIGN IN',
            style: const TextStyle(
              fontFamily: 'CircularStd',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = onSignInTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
