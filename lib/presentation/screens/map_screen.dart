import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Community Map',
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
              Icons.map_outlined,
              size: 64,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Community Members Map',
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
