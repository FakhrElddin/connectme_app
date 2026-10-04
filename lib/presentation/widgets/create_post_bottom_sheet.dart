import 'package:connectme_app/presentation/widgets/picker_button.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/custom_gradient_button.dart';

class CreatePostBottomSheet extends StatelessWidget {
  const CreatePostBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (context) => const CreatePostBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Create Image Post',
              style: TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextColor,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.homeBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lightGreyColor, width: 1.5),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: AppColors.greyColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Select an image to share',
                    style: TextStyle(
                      fontFamily: 'CircularStd',
                      fontSize: 14,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PickerButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PickerButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              text: 'Publish',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
