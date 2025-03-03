//
// import 'package:askme/app/global/common_widgets/custom_text/custom_text.dart';
// import 'package:askme/app/global/controller/bottom_nav_controller.dart';
// import 'package:askme/app/utils/app_colors.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class CommonBottomNavBar extends StatelessWidget {
//   CommonBottomNavBar({super.key});
//
//   // final BottomNavbarController bottomNavbarController =
//   //     BottomNavbarController.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       bottomNavigationBar: Obx(() {
//         return CurvedNavigationBar(
//           height: 66,
//           index: bottomNavbarController.selectedIndex.value,
//           onTap: (index) {
//             bottomNavbarController.onItemTapped(index); // Pass context here
//           },
//           color: AppColors.f32Color,
//           buttonBackgroundColor: AppColors.greenColor,
//           backgroundColor: Colors.transparent,
//           animationCurve: Curves.easeInOut,
//           animationDuration: const Duration(milliseconds: 500),
//           items: [
//             // _buildNavItem(
//             //   index: 0,
//             //   label: "Home",
//             //   iconSelected: Assets.icons.home.svg(),
//             //   iconUnselected: Assets.icons.home.svg(color: AppColors.innerText),
//             // ),
//             // _buildNavItem(
//             //   index: 1,
//             //   label: "Analytics",
//             //   iconSelected: Assets.icons.analytics.svg(color: AppColors.black),
//             //   iconUnselected:
//             //   Assets.icons.analytics.svg(color: AppColors.innerText),
//             // ),
//             // _buildNavItem(
//             //   index: 2,
//             //   label: "Create",
//             //   iconSelected: Assets.icons.create.svg(color: AppColors.black),
//             //   iconUnselected: Assets.icons.create.svg(),
//             // ),
//             // _buildNavItem(
//             //   index: 3,
//             //   label: "Bank",
//             //   iconSelected: Assets.icons.bank.svg(color: AppColors.black),
//             //   iconUnselected: Assets.icons.bank.svg(),
//             // ),
//             // _buildNavItem(
//             //   index: 4,
//             //   label: "My Uploads",
//             //   iconSelected: Assets.icons.myuploads.svg(color: AppColors.black),
//             //   iconUnselected: Assets.icons.myuploads.svg(),
//             // ),
//           ],
//         );
//       }),
//       body: Obx(() {
//         return AnimatedSwitcher(
//           duration: const Duration(milliseconds: 500),
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//           child: bottomNavbarController.userAllScreens[
//           bottomNavbarController.selectedIndex.value],
//         );
//       }),
//     );
//   }
//
//   Widget _buildNavItem({
//     required int index,
//     required String label,
//     required Widget iconSelected,
//     required Widget iconUnselected,
//   }) {
//     final isSelected = bottomNavbarController.selectedIndex.value == index;
//
//     return Padding(
//       padding: EdgeInsets.only(top: isSelected ? 0 : 8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           isSelected ? iconSelected : iconUnselected,
//           if (!isSelected)
//             CustomText(
//               text: label,
//               fontSize: 12,
//               color: AppColors.whiteColor,
//             ),
//         ],
//       ),
//     );
//   }
// }
