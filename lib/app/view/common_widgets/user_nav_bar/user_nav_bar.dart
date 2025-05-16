import 'dart:developer';

import 'package:barber_time/app/core/custom_assets/assets.gen.dart' show Assets;
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart' show AppColors;
import 'package:barber_time/app/utils/app_strings.dart' show AppStrings;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes.dart';
import '../custom_text/custom_text.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final UserRole role;

  const CustomNavBar({required this.currentIndex, required this.role, super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> with SingleTickerProviderStateMixin {
  late int bottomNavIndex;
  bool showFABOptions = false;

  late List<({
  String route,
  Widget selectedIcon,
  Widget unselectedIcon,
  String label
  })> _navItems;

  @override
  void initState() {
    super.initState();
    bottomNavIndex = widget.currentIndex;
    setNavigationItems(widget.role);
  }

  void setNavigationItems(UserRole role) {
    switch (role) {
      case UserRole.owner:
        _navItems = [
          (
          route: RoutePath.ownerHomeScreen,
          selectedIcon: Assets.images.homeSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.homeUnselected.image(color: Colors.black),
          label: AppStrings.home,
          ),
          (
          route: RoutePath.ownerQue,
          selectedIcon: Assets.images.queSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.queUnselected.image(color: Colors.black),
          label: AppStrings.que,
          ),
          (
          route: '', // FAB Placeholder
          selectedIcon: const SizedBox.shrink(),
          unselectedIcon: const SizedBox.shrink(),
          label: '',
          ),
          (
          route: RoutePath.ownerHiringScreen,
          selectedIcon: Assets.images.hiringSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.hiringUnselected.image(color: Colors.black),
          label: AppStrings.hiring,
          ),
          (
          route: RoutePath.profileScreen,
          selectedIcon: Assets.images.profileSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.profileUnselected.image(color: Colors.black),
          label: AppStrings.profile,
          ),
        ];
        break;

      case UserRole.barber:
        _navItems = [
          (
          route: RoutePath.barberHomeScreen,
          selectedIcon: Assets.images.homeSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.homeUnselected.image(color: Colors.black),
          label: AppStrings.home,
          ),
          (
          route: RoutePath.inboxScreen,
          selectedIcon: Assets.images.chartSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.chartUnselected.image(color: Colors.black),
          label: AppStrings.chat,
          ),
          (
          route: '', // FAB Placeholder
          selectedIcon: const SizedBox.shrink(),
          unselectedIcon: const SizedBox.shrink(),
          label: 'Post',
          ),
          (
          route: RoutePath.barberHistoryScreen,
          selectedIcon: Assets.images.historySelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.historyUnselected.image(color: Colors.black),
          label: "History",
          ),
          (
          route: RoutePath.profileScreen,
          selectedIcon: Assets.images.profileSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.profileUnselected.image(color: Colors.black),
          label: AppStrings.profile,
          ),
        ];
        break;

      case UserRole.user:
      default:
        _navItems = [
          (
          route: RoutePath.homeScreen,
          selectedIcon: Assets.images.homeSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.homeUnselected.image(color: Colors.black),
          label: AppStrings.home,
          ),
          (
          route: RoutePath.berberTimes,
          selectedIcon: Assets.images.queSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.queUnselected.image(color: Colors.black),
          label: AppStrings.que,
          ),
          (
          route: '', // FAB Placeholder
          selectedIcon: const SizedBox.shrink(),
          unselectedIcon: const SizedBox.shrink(),
          label: '',
          ),
          (
          route: RoutePath.savedScreen,
          selectedIcon: Assets.images.savedSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.savedUnselected.image(color: Colors.black),
          label: AppStrings.saved,
          ),
          (
          route: RoutePath.userProfileScreen,
          selectedIcon: Assets.images.profileSelected.image(color: AppColors.secondary),
          unselectedIcon: Assets.images.profileUnselected.image(color: Colors.black),
          label: AppStrings.profile,
          ),
        ];
        break;
    }
  }

  void _onTap(int index) {
    if (index == 2) {
      // Center FAB tapped - toggle options
      setState(() {
        showFABOptions = !showFABOptions;
      });
    } else if (bottomNavIndex != index) {
      setState(() {
        bottomNavIndex = index;
        showFABOptions = false;
      });
      AppRouter.route.goNamed(_navItems[index].route, extra: widget.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.h + (showFABOptions ? 70.h : 0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 88.h,
            decoration: const BoxDecoration(color: AppColors.white),
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                if (index == 2) {
                  // Spacer for FAB center button
                  return const SizedBox(width: 56);
                }

                final item = _navItems[index];

                return InkWell(
                  onTap: () => _onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      bottomNavIndex == index ? item.selectedIcon : item.unselectedIcon,
                      SizedBox(height: 4.h),
                      CustomText(
                        text: item.label,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: bottomNavIndex == index ? AppColors.secondary : AppColors.black,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Center Floating Button
          Positioned(
            bottom: 38.h, // Slightly up for better overlap
            child: GestureDetector(
              onTap: () => _onTap(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.secondary,
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),

          // Expanded FAB Options
          if (showFABOptions)
            Positioned(
              bottom: 88.h + 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFABOption(icon: Icons.chat, onTap: (){
                      AppRouter.route
                          .pushNamed(RoutePath.chatScreen,extra: UserRole.user );
                    }),
                    SizedBox(width: 24.w),
                    _buildFABOption(icon: Icons.qr_code,onTap: (){
                      AppRouter.route
                          .pushNamed(RoutePath.scannerScreen,extra: UserRole.user );
                    }),
                    SizedBox(width: 24.w),
                    _buildFABOption(icon: Icons.book, onTap: (){
                      AppRouter.route
                          .pushNamed(RoutePath.bookingScreen,extra: UserRole.user );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFABOption({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
        setState(() {
          showFABOptions = false;
        });
      },
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white,
        child: Icon(icon, color: AppColors.secondary),
      ),
    );
  }
}
