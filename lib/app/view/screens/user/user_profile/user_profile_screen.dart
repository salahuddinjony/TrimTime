import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/permission_button/permission_button.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart' show CustomNavBar;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: CustomNavBar(currentIndex: 4, role: userRole),



      ///============================ Header ===============================
      appBar: AppBar(
        title: const CustomText(
          text: AppStrings.profile,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
      ),

      ///============================ body ===============================
      body: SingleChildScrollView(
        child: ClipPath(
          clipper: CurvedBannerClipper(),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCCEDC4AC), // First color (with opacity)
                  Color(0xFFE9874E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //TOdo=====Header====
                  Center(
                      child: Column(
                        children: [
                          CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: AppConstants.demoImage,
                              height: 102,
                              width: 102),
                          const CustomText(
                            top: 8,
                            text: "Jane Cooper",
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                          const CustomText(
                            top: 8,
                            text: "Jane@example.com",
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ],
                      )),

                  //TOdo=====personalInformation====
                  CustomMenuCard(
                    onTap: () {
                      AppRouter.route
                          .pushNamed(RoutePath.personalInfo, extra: userRole);
                    },
                    text: AppStrings.personalInformation,
                    icon: Assets.icons.personalInfo.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),







                  //chat=========
                  userRole == UserRole.user
                      ? CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.inboxScreen,
                          extra: userRole);
                    },
                    text: AppStrings.chat,
                    icon: Assets.images.chartSelected.image(

                    ),
                  )
                      : const SizedBox(),

                  //=========
                  //TOdo=====myFeed====
                  CustomMenuCard(
                    onTap: () {
                      AppRouter.route
                          .pushNamed(RoutePath.myFeed, extra: userRole);
                    },
                    text: AppStrings.myFeedBack,
                    icon: Assets.icons.myFeedBack.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),









                  //TOdo=====following====

                  userRole == UserRole.barber
                      ? const SizedBox()
                      : CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.followingScreen,
                          extra: userRole);
                    },
                    text: AppStrings.myFollowing,
                    icon: Assets.icons.flowing.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),

                  //TOdo=========

                  userRole == UserRole.user
                      ? CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.myLoyality,
                          extra: userRole);
                    },
                    text: "My Loyalty Rewards",
                    icon: Assets.icons.loyality.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  )
                      : const SizedBox(),

                  //TOdo=========

                  userRole == UserRole.user
                      ? CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.bookingScreen,
                          extra: userRole);
                    },
                    text: "My Booking",
                    icon: Assets.images.myBooking.image(

                    ),
                  )
                      : const SizedBox(),

                  //=========
                  //TOdo=====settings====
                  CustomMenuCard(
                    onTap: () {
                      AppRouter.route
                          .pushNamed(RoutePath.settings, extra: userRole);
                    },
                    text: AppStrings.settings,
                    icon: Assets.icons.settings.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),
                  //=========
                  //TOdo=====logOut====
                  CustomMenuCard(
                    onTap: () {
                      permissionPopUp(
                          title: AppStrings.areYouSureYouWantToLogOut,
                          context: context,
                          ontapNo: () {
                            context.pop();
                          },
                          ontapYes: () {
                            AppRouter.route.goNamed(
                              RoutePath.choseRoleScreen,
                            );
                          });
                    },
                    isArrow: true,
                    isTextRed: true,
                    text: AppStrings.logOut,
                    icon: Assets.icons.logout.svg(),
                  ),

                  SizedBox(
                    height: 25.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
