import 'package:connectme_app/presentation/widgets/home_tab_app_bar.dart';
import 'package:connectme_app/presentation/screens/feeds_screen.dart';
import 'package:connectme_app/presentation/screens/map_screen.dart';
import 'package:connectme_app/presentation/widgets/create_post_bottom_sheet.dart';
import 'package:connectme_app/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:connectme_app/presentation/widgets/maps_tab_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final List<Widget> tabs = const [FeedsScreen(), MapScreen()];
  final List<PreferredSizeWidget?> appBars = const [
    HomeTabAppBar(),
    MapsTabAppBar(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: AppColors.homeBackgroundColor,
      appBar: widget.appBars[currentNavIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
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
      ),
      body: widget.tabs[currentNavIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentNavIndex,
        onHomeTap: () {
          if (currentNavIndex != 0) {
            setState(() {
              currentNavIndex = 0;
            });
          }
        },
        onMapsTap: () {
          if (currentNavIndex != 1) {
            setState(() {
              currentNavIndex = 1;
            });
          }
        },
      ),
    );
  }
}
