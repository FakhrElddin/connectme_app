import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PickerButton extends StatelessWidget {
  const PickerButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.homeBackgroundColor;
    final effectiveFg = foregroundColor ?? AppColors.primaryColor;
    final effectiveBorder = borderColor ?? AppColors.primaryColor;

    return Material(
      color: effectiveBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: effectiveFg.withValues(alpha: 0.15),
        highlightColor: effectiveFg.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: effectiveBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: effectiveFg),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'CircularStd',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: effectiveFg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
