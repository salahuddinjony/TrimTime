// // import 'package:barber_time/app/utils/enums/user_role.dart';
// // import 'package:barber_time/app/view/screens/barber/barber_history/barber_history_screen.dart';
// // import 'package:barber_time/app/view/screens/barber/barber_home/barber_home_screen.dart';
// // import 'package:barber_time/app/view/screens/barber/barber_profile/barber_profile.dart';
// // import 'package:barber_time/app/view/screens/owner/owner_hiring/owner_hiring_screen.dart';
// // import 'package:barber_time/app/view/screens/owner/owner_home/owner_home_screen.dart';
// // import 'package:barber_time/app/view/screens/owner/owner_message/owner_messaging_screen.dart';
// // import 'package:barber_time/app/view/screens/user/home/home_screen.dart';
// // import 'package:barber_time/app/view/screens/user/que/que_screen.dart';
// // import 'package:barber_time/app/view/screens/user/scanner/scanner_screen.dart';
// // import 'package:flutter/material.dart';
// //
// // class RoleBasedBottomNav extends StatefulWidget {
// //   final UserRole role; // Enum UserRole
// //   const RoleBasedBottomNav({super.key, required this.role});
// //
// //   @override
// //   _RoleBasedBottomNavState createState() => _RoleBasedBottomNavState();
// // }
// //
// // class _RoleBasedBottomNavState extends State<RoleBasedBottomNav> {
// //   int _selectedIndex = 0;
// //   late List<Widget> _pages;
// //   late List<BottomNavigationBarItem> _navItems;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pages = getScreensByRole(widget.role);
// //     _navItems = getNavItemsByRole(widget.role);
// //   }
// //
// //   List<Widget> getScreensByRole(UserRole role) {
// //     switch (role) {
// //       case UserRole.owner:
// //         return [
// //           const OwnerHomeScreen(),
// //           const OwnerMessagingScreen(),
// //           const OwnerHiringScreen()
// //         ];
// //       case UserRole.barber:
// //         return [
// //           const BarberHomeScreen(),
// //           const BarberHistoryScreen(),
// //           const BarberProfile()
// //         ];
// //       case UserRole.user:
// //
// //         return [const HomeScreen(), const QueScreen(), const ScannerScreen()];
// //     }
// //   }
// //
// //   List<BottomNavigationBarItem> getNavItemsByRole(UserRole role) {
// //     switch (role) {
// //       case UserRole.owner:
// //         return [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.book_online), label: "Bookings"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// //         ];
// //       case UserRole.barber:
// //         return [
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.dashboard), label: "Dashboard"),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.schedule), label: "Schedule"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// //         ];
// //       case UserRole.user:
// //       default:
// //         return [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
// //           BottomNavigationBarItem(
// //               icon: Icon(Icons.shopping_cart), label: "Appointments"),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
// //         ];
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // body: _pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (index) => setState(() => _selectedIndex = index),
// //         items: _navItems,
// //       ),
// //     );
// //   }
// // }
//
// import 'package:barber_time/app/core/route_path.dart';
// import 'package:barber_time/app/core/routes.dart';
// import 'package:barber_time/app/utils/app_colors.dart';
// import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// import 'custom_assets/assets.gen.dart';
//
// class BottomNavbar extends StatefulWidget {
//   final int currentIndex;
//
//   const BottomNavbar({required this.currentIndex, super.key});
//
//   @override
//   State<BottomNavbar> createState() => _NavBarState();
// }
//
// class _NavBarState extends State<BottomNavbar> {
//   late int bottomNavIndex;
//
//   final List<Widget> unselectedIcon = [
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//   ];
//
//   final List<Widget> selectedIcon = [
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//     Assets.icons.faq.svg(),
//   ];
//
//   final List<String> textList = [
//  "Faq", "Faq", "Faq",
//     "Faq",
//   ];
//
//   @override
//   void initState() {
//     bottomNavIndex = widget.currentIndex;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: AppColors.normalHover,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//         ),
//       ),
//       height: 95.h,
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.5.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(
//           unselectedIcon.length,
//           (index) => InkWell(
//             onTap: () => onTap(index),
//             child: Column(
//               children: [
//                 bottomNavIndex == index
//                     ? selectedIcon[index]
//                     : unselectedIcon[index],
//                 CustomText(
//                   text: textList[index],
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: bottomNavIndex == index
//                       ? AppColors.gray300
//                       : AppColors.gray300,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void onTap(int index) {
//     if (index == 0) {
//       if (!(widget.currentIndex == 0)) {
//         AppRouter.route.goNamed(RoutePath.ownerHomeScreen,);
//         // Get.to(() => const OwnerHomeScreen());
//       }
//     } else if (index == 1) {
//       if (!(widget.currentIndex == 1)) {
//         AppRouter.route.goNamed(RoutePath.ownerMessagingScreen,);
//       }
//     } else if (index == 2) {
//       if (!(widget.currentIndex == 2)) {
//         AppRouter.route.goNamed(RoutePath.ownerHomeScreen,);
//       }
//     }
//     //
//     else if (index == 3) {
//       if (!(widget.currentIndex == 3)) {
//         AppRouter.route.goNamed(RoutePath.ownerMessagingScreen,);
//       }
//     }
//   }
// }


import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'custom_assets/assets.gen.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';

class BottomNavbar extends StatefulWidget {
  final int currentIndex;
  final UserRole role; // ✅ UserRole যুক্ত করা হলো

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
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
        ];
        selectedIcon = [
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.gender.svg(),
        ];
        textList = ["Home", "Messages", "Hiring", "Profile"];
        routeNames = [
          RoutePath.ownerHomeScreen,
          RoutePath.ownerMessagingScreen,
          RoutePath.ownerMessagingScreen,
          RoutePath.ownerMessagingScreen,
        ];
        break;

      case UserRole.barber:
        unselectedIcon = [
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
        ];
        selectedIcon = [
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
          Assets.icons.terms.svg(),
        ];
        textList = ["Dashboard", "Schedule", "History", "Profile"];
        routeNames = [
          RoutePath.ownerHomeScreen,
          RoutePath.ownerHomeScreen,
          RoutePath.ownerHomeScreen,
          RoutePath.ownerHomeScreen,
        ];
        break;

      case UserRole.user:
      default:
        unselectedIcon = [
          Assets.icons.gender.svg(),
          Assets.icons.settings.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.settings.svg(),
        ];
        selectedIcon = [
          Assets.icons.gender.svg(),
          Assets.icons.settings.svg(),
          Assets.icons.gender.svg(),
          Assets.icons.settings.svg(),
        ];
        textList = ["Home", "Appointments", "Scanner", "Profile"];
        routeNames = [
          RoutePath.homeScreen,
          RoutePath.homeScreen,
          RoutePath.homeScreen,
          RoutePath.homeScreen,
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
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
                bottomNavIndex == index
                    ? selectedIcon[index]
                    : unselectedIcon[index],
                SizedBox(height: 5.h),
                CustomText(
                  text: textList[index],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: bottomNavIndex == index
                      ? AppColors.white50
                      : AppColors.gray300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Navigation Logic
  void onTap(int index, BuildContext context) {
    if (bottomNavIndex != index) {
      setState(() => bottomNavIndex = index);
      context.pushNamed(routeNames[index]); // ✅ প্রতিটি role-এর জন্য আলাদা route
    }
  }
}
