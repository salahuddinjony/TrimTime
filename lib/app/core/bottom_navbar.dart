import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final UserRole role;

  const BottomNavbar({required this.currentIndex, required this.role, super.key});

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
    bottomNavIndex = widget.currentIndex;
    setNavigationItems(widget.role);
    super.initState();
  }

  void setNavigationItems(UserRole role) {
    switch (role) {
      case UserRole.owner:
        unselectedIcon = [
          Assets.images.homeUnselected.image(),
          Assets.images.chartUnselected.image(),
          Assets.images.hiringUnselected.image(),
          Assets.images.profileUnselected.image(),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(),
          Assets.images.chartSelected.image(),
          Assets.images.hiringSelected.image(),
          Assets.images.profileUnselected.image(),
        ];
        textList = [AppStrings.home, AppStrings.chat, AppStrings.hiring, AppStrings.profile];
        routeNames = [
          RoutePath.ownerHomeScreen,
          RoutePath.inboxScreen,
          RoutePath.ownerHiringScreen,
          RoutePath.profileScreen,
        ];
        break;
      case UserRole.barber:
        unselectedIcon = [
          Assets.images.homeUnselected.image(),
          Assets.images.chartUnselected.image(),
          Assets.images.camera.image(),
          Assets.images.historyUnselected.image(),
          Assets.images.profileUnselected.image(),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(),
          Assets.images.chartSelected.image(),
          Assets.images.camera.image(),
          Assets.images.historySelected.image(),
          Assets.images.profileUnselected.image(),
        ];
        textList = [AppStrings.home, AppStrings.chat, '', "History", AppStrings.profile];
        routeNames = [
          RoutePath.barberHomeScreen,
          RoutePath.barberChat,
          RoutePath.barberFeed,
          RoutePath.barberHistoryScreen,
          RoutePath.profileScreen,
        ];
        break;
      case UserRole.user:
      default:
        unselectedIcon = [
          Assets.images.homeUnselected.image(),
          Assets.images.queUnselected.image(),
          Assets.images.scanner.image(),
          Assets.images.savedUnselected.image(),
          Assets.images.profileUnselected.image(),
        ];
        selectedIcon = [
          Assets.images.homeSelected.image(),
          Assets.images.queSelected.image(),
          Assets.images.scanner.image(),
          Assets.images.savedSelected.image(),
          Assets.images.profileSelected.image(),
        ];
        textList = [AppStrings.home,AppStrings.que,'',AppStrings.saved,AppStrings.profile];
        routeNames = [
          RoutePath.homeScreen,
          RoutePath.queScreen,
          RoutePath.scannerScreen,
          RoutePath.savedScreen,
          RoutePath.profileScreen
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      height: 95.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          unselectedIcon.length,
              (index) => InkWell(
            onTap: () => onTap(index, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (index == 2 && widget.role == UserRole.barber)
                        ? AppColors.secondary
                        : AppColors.bottomColor,
                  ),
                  height: (index == 2 && widget.role == UserRole.barber) ? 40.h : 30.h,
                  width: (index == 2 && widget.role == UserRole.barber) ? 40.w : 24.w,
                  child: bottomNavIndex == index ? selectedIcon[index] : unselectedIcon[index],
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: textList[index],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: bottomNavIndex == index ? AppColors.white50 : AppColors.gray300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTap(int index, BuildContext context) {
    if (bottomNavIndex != index) {
      setState(() => bottomNavIndex = index);
      // Pass userRole as extra when navigating
      context.goNamed(
        routeNames[index],
        extra: widget.role,  // Pass userRole here
      );
    }
  }
}

