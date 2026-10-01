import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    this.onGoogleTap,
    this.onFacebookTap,
  });

  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'or LOG IN by',
          style: TextStyle(
            fontFamily: 'CircularStd',
            fontSize: 14,
            color: AppColors.darkGreyColor,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onGoogleTap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 40,
                height: 40,
                child: SvgPicture.asset(
                  'assets/icons/ic_google.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: onFacebookTap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 40,
                height: 40,
                child: SvgPicture.asset(
                  'assets/icons/ic_facebook.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
