import 'package:connectme_app/presentation/widgets/custom_floating_action_button.dart';
import 'package:connectme_app/presentation/widgets/home_tab_app_bar.dart';
import 'package:connectme_app/presentation/screens/feeds_screen.dart';
import 'package:connectme_app/presentation/screens/map_screen.dart';
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
      floatingActionButton: const CustomFloatingActionButton(),
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
