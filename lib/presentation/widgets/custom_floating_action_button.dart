import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/create_post_bottom_sheet.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.lightPurpleColor, AppColors.darkPurpleColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: FloatingActionButton(
        onPressed: () {
          CreatePostBottomSheet.show(context);
        },
        elevation: 0,
        backgroundColor: AppColors.transparentColor,
        shape: const CircleBorder(),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
