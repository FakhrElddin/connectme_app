import 'package:flutter/material.dart';

class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
      height: screenHeight * 0.38,
      width: double.infinity,
      child: Image.asset(
        'assets/images/auth_header.png',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
