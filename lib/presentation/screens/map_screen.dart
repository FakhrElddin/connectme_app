import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.homeBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 64, color: AppColors.primaryColor),
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
