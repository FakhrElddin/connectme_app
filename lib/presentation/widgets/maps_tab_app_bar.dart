import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MapsTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapsTabAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
