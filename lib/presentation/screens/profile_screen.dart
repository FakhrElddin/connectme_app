import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'CircularStd',
            fontWeight: FontWeight.bold,
            color: AppColors.darkTextColor,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint_rounded,
              size: 64,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Biometric Protected Profile',
              style: TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
