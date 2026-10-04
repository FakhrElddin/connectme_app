import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/presentation/widgets/category_tabs.dart';
import 'package:connectme_app/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: AppColors.transparentColor,
      backgroundColor: AppColors.whiteColor,
      title: SizedBox(
        height: 44,
        child: CustomTextFormField(
          hintText: 'Search',
          textInputAction: TextInputAction.done,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/icons/search_ic.svg'),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightGreyColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primaryColor,
              size: 24,
            ),
          ),
        ),
      ],
      bottom: const CategoryTabs(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    kToolbarHeight + CategoryTabs.preferredHeight,
  );
}
