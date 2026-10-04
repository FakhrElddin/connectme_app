import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onHomeTap,
    required this.onMapsTap,
  });

  final int currentIndex;
  final void Function()? onHomeTap;
  final void Function()? onMapsTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: AppColors.whiteColor,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onHomeTap,
              icon: SvgPicture.asset(
                currentIndex == 0
                    ? 'assets/icons/home_ic_selected.svg'
                    : 'assets/icons/home_ic.svg',
                height: currentIndex == 0 ? 30 : 24,
                width: currentIndex == 0 ? 30 : 24,
              ),
            ),
            IconButton(
              onPressed: onMapsTap,
              icon: SvgPicture.asset(
                currentIndex == 1
                    ? 'assets/icons/maps_ic_selected.svg'
                    : 'assets/icons/maps_ic.svg',
                height: currentIndex == 1 ? 30 : 24,
                width: currentIndex == 1 ? 30 : 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
