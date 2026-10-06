import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DeviceInfoTile extends StatelessWidget {
  const DeviceInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 12,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
