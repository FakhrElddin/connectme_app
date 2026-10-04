import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 52.0,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback? onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.darkPurpleColor, AppColors.lightPurpleColor],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      // Material is required here so InkWell can render its ripple splash effect
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
