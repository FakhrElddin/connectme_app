import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

enum AppDialogType {
  success,
  error,
  info,
}

extension AppDialogTypeExtension on AppDialogType {
  Color get color {
    switch (this) {
      case AppDialogType.success:
        return AppColors.successColor;
      case AppDialogType.error:
        return AppColors.redColor;
      case AppDialogType.info:
        return AppColors.infoColor;
    }
  }

  String get iconPath {
    switch (this) {
      case AppDialogType.success:
        return 'assets/images/dialog_success.svg';
      case AppDialogType.error:
        return 'assets/images/dialog_error.svg';
      case AppDialogType.info:
        return 'assets/images/dialog_info.svg';
    }
  }
}

class CustomAppDialog extends StatelessWidget {
  const CustomAppDialog({
    super.key,
    required this.title,
    required this.description,
    this.dialogType = AppDialogType.info,
    this.btnOkText,
    this.btnOkOnPress,
    this.btnCancelText,
    this.btnCancelOnPress,
  });

  final String title;
  final String description;
  final AppDialogType dialogType;
  final String? btnOkText;
  final VoidCallback? btnOkOnPress;
  final String? btnCancelText;
  final VoidCallback? btnCancelOnPress;

  // ---------------------------------------------------------------------------
  // Static Helper Methods (Self-contained Component Pattern)
  // ---------------------------------------------------------------------------

  /// Shows the dialog with custom parameters and smooth entrance animation.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String description,
    AppDialogType dialogType = AppDialogType.info,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    String? btnCancelText,
    VoidCallback? btnCancelOnPress,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'AppDialog',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, anim1, anim2) {
        return CustomAppDialog(
          title: title,
          description: description,
          dialogType: dialogType,
          btnOkText: btnOkText,
          btnOkOnPress: btnOkOnPress,
          btnCancelText: btnCancelText,
          btnCancelOnPress: btnCancelOnPress,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedAnimation = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  /// Convenient helper to show a Success dialog.
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String title,
    required String description,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    String? btnCancelText,
    VoidCallback? btnCancelOnPress,
    bool barrierDismissible = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      description: description,
      dialogType: AppDialogType.success,
      btnOkText: btnOkText,
      btnOkOnPress: btnOkOnPress,
      btnCancelText: btnCancelText,
      btnCancelOnPress: btnCancelOnPress,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Convenient helper to show an Error dialog.
  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    required String description,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    String? btnCancelText,
    VoidCallback? btnCancelOnPress,
    bool barrierDismissible = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      description: description,
      dialogType: AppDialogType.error,
      btnOkText: btnOkText,
      btnOkOnPress: btnOkOnPress,
      btnCancelText: btnCancelText,
      btnCancelOnPress: btnCancelOnPress,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Convenient helper to show an Info dialog.
  static Future<T?> showInfo<T>({
    required BuildContext context,
    required String title,
    required String description,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    String? btnCancelText,
    VoidCallback? btnCancelOnPress,
    bool barrierDismissible = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      description: description,
      dialogType: AppDialogType.info,
      btnOkText: btnOkText,
      btnOkOnPress: btnOkOnPress,
      btnCancelText: btnCancelText,
      btnCancelOnPress: btnCancelOnPress,
      barrierDismissible: barrierDismissible,
    );
  }

  // ---------------------------------------------------------------------------
  // Build Method
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge Icon
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dialogType.color.withValues(alpha: 0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                dialogType.iconPath,
                width: 66,
                height: 66,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.darkGreyColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),

            // Buttons
            DialogActionButtons(
              primaryColor: dialogType.color,
              btnOkText: btnOkText,
              btnOkOnPress: btnOkOnPress,
              btnCancelText: btnCancelText,
              btnCancelOnPress: btnCancelOnPress,
            ),
          ],
        ),
      ),
    );
  }
}

class DialogActionButtons extends StatelessWidget {
  const DialogActionButtons({
    super.key,
    required this.primaryColor,
    this.btnOkText,
    this.btnOkOnPress,
    this.btnCancelText,
    this.btnCancelOnPress,
  });

  final Color primaryColor;
  final String? btnOkText;
  final VoidCallback? btnOkOnPress;
  final String? btnCancelText;
  final VoidCallback? btnCancelOnPress;

  @override
  Widget build(BuildContext context) {
    final bool hasCancel = btnCancelOnPress != null;

    if (hasCancel) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                btnCancelOnPress?.call();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(
                  color: AppColors.greyColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                btnCancelText ?? 'Cancel',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                btnOkOnPress?.call();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                btnOkText ?? 'OK',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          btnOkOnPress?.call();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          btnOkText ?? 'OK',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
