import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class CategoryTabs extends StatefulWidget implements PreferredSizeWidget {
  const CategoryTabs({super.key});

  static const double preferredHeight = 48.0;

  final List<String> categories = const ['Popular', 'Trending', 'Recent'];

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();

  @override
  Size get preferredSize => const Size.fromHeight(preferredHeight);
}

class _CategoryTabsState extends State<CategoryTabs> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CategoryTabs.preferredHeight,
      color: AppColors.whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: List.generate(
          widget.categories.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? const Color(0XFFF1F1FD)
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: selectedIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    widget.categories[index],
                    style: TextStyle(
                      fontFamily: 'CircularStd',
                      fontSize: 16,
                      fontWeight: selectedIndex == index
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: selectedIndex == index
                          ? AppColors.primaryColor
                          : AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
