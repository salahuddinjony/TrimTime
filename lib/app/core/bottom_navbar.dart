

import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final UserRole role;

  const BottomNavbar(
      {required this.currentIndex, required this.role, super.key});

  @override
  State<BottomNavbar> createState() => _NavBarState();
}

class _NavBarState extends State<BottomNavbar> {
  late int bottomNavIndex;
  late List<Widget> unselectedIcon;
  late List<Widget> selectedIcon;
  late List<String> textList;
  late List<String> routeNames;

  @override
  void initState() {
    super.initState();
    bottomNavIndex = widget.currentIndex;
    setNavigationItems(widget.role);
  }

  void setNavigationItems(UserRole role) {
    switch (role) {
      case UserRole.owner:
        unselectedIcon = [
          Assets.images.homeUnselected.image(color: Colors.black),
          Assets.images.queUnselected.image(color: Colors.black),
          Assets.images.camera.image(color: Colors.black),
          Assets.images.hiringUnselected.image(color: Colors.black),
          Assets.images.profileUnselected.image(color: Colors.black),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(color: Colors.black),
          Assets.images.queUnselected.image(color: Colors.black),
          Assets.images.camera.image(color: Colors.black),
          Assets.images.hiringSelected.image(color: Colors.black),
          Assets.images.profileUnselected.image(color: Colors.black),
        ];
        textList = [
          AppStrings.home,
          AppStrings.que,
          "",
          AppStrings.hiring,
          AppStrings.profile
        ];
        routeNames = [
          RoutePath.ownerHomeScreen,
          RoutePath.ownerQue,
          RoutePath.barberFeed,
          RoutePath.ownerHiringScreen,
          RoutePath.profileScreen,
        ];
        break;
      case UserRole.barber:
        unselectedIcon = [
          Assets.images.homeUnselected.image(color: Colors.black),
          Assets.images.chartUnselected.image(color: Colors.black),
          Assets.images.camera.image(color: Colors.black),
          Assets.images.historyUnselected.image(color: Colors.black),
          Assets.images.profileUnselected.image(color: Colors.black),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(color: Colors.black),
          Assets.images.chartSelected.image(color: Colors.black),
          Assets.images.camera.image(color: Colors.black),
          Assets.images.historySelected.image(color: Colors.black),
          Assets.images.profileUnselected.image(color: Colors.black),
        ];
        textList = [
          AppStrings.home,
          AppStrings.chat,
          'Post',
          "History",
          AppStrings.profile
        ];
        routeNames = [
          RoutePath.barberHomeScreen,
          RoutePath.inboxScreen,
          RoutePath.barberFeed,
          RoutePath.barberHistoryScreen,
          RoutePath.profileScreen,
        ];
        break;
      case UserRole.user:
      default:
        unselectedIcon = [
          Assets.images.homeUnselected.image(color: Colors.black),
          Assets.images.queUnselected.image(color: Colors.black),
          Assets.images.booking.image(color: Colors.black),
          Assets.images.savedUnselected.image(color: Colors.black),
          Assets.images.profileUnselected.image(color: Colors.black),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(color: Colors.black),
          Assets.images.queSelected.image(color: Colors.black),
          Assets.images.booking.image(color: Colors.black),
          Assets.images.savedSelected.image(color: Colors.black),
          Assets.images.profileSelected.image(color: Colors.black),
        ];
        textList = [
          AppStrings.home,
          AppStrings.que,
          'Booking',
          AppStrings.saved,
          AppStrings.profile
        ];
        routeNames = [
          RoutePath.homeScreen,
          RoutePath.berberTimes,
          RoutePath.bookingScreen,
          RoutePath.savedScreen,
          RoutePath.profileScreen
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: ValueKey<int>(bottomNavIndex),
      // Ensure the widget is recreated when the index changes
      index: bottomNavIndex,
      items: <Widget>[

        _buildNavItem(unselectedIcon[0], selectedIcon[0], textList[0],
            bottomNavIndex == 0),
        _buildNavItem(unselectedIcon[1], selectedIcon[1], textList[1],
            bottomNavIndex == 1),
        _buildNavItem(unselectedIcon[2], selectedIcon[2], textList[2],
            bottomNavIndex == 2),
        _buildNavItem(unselectedIcon[3], selectedIcon[3], textList[3],
            bottomNavIndex == 3),
        _buildNavItem(unselectedIcon[4], selectedIcon[4], textList[4],
            bottomNavIndex == 4),
      ],
      color: AppColors.navColor,
      backgroundColor: Colors.white,
      buttonBackgroundColor: AppColors.navColor,
      animationCurve: Curves.easeInOut,
      // Animation curve
      onTap: (index) {
        setState(() {
          bottomNavIndex = index;
        });
        context.goNamed(
          routeNames[index],
          extra: widget.role, // Pass userRole here
        );
      },
    );
  }

  // Custom method to build each navigation item
  Widget _buildNavItem(Widget unselectedIcon, Widget selectedIcon, String text,
      bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSelected ? selectedIcon : unselectedIcon,
          // Display selected or unselected icon
          const SizedBox(height: 4.0),
          // Space between icon and text
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.secondary : AppColors.black,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
