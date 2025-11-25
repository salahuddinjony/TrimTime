import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/permission_button/permission_button.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart'
    show CustomNavBar;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/models/profile_response_model.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import '../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({
    super.key,
  });

  final OwnerProfileController ownerProfileController =
      Get.find<OwnerProfileController>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    }

    debugPrint("==================={userRole?.name}");
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
                  Color(0xCCEDBDA1),
                  Color(0xFFEA905D),
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
                      try {
                        // Create a proper ProfileData instance
                        final profileData = ProfileData(
                          id: 'user_123', // Replace with actual user ID
                          fullName: 'Jane Cooper',
                          email: 'Jane@example.com',
                          phoneNumber: '+1234567890',
                          address: 'User Address',
                          dateOfBirth: DateTime.now().subtract(
                              const Duration(days: 365 * 25)), // 25 years old
                          gender: 'female',
                          followerCount: 0,
                          followingCount: 0,
                          role: userRole?.name ?? '',
                        );

                        // Ensure controller exists or create it
                        if (!Get.isRegistered<OwnerProfileController>()) {
                          Get.put(OwnerProfileController());
                        }

                        AppRouter.route
                            .pushNamed(RoutePath.personalInfo, extra: {
                          'userRole': userRole,
                          'profileData': profileData,
                          'controller': Get.find<OwnerProfileController>(),
                        });
                      } catch (e) {
                        // Fallback: navigate to a simpler profile screen
                        debugPrint('Error navigating to PersonalInfo: $e');
                        // You might want to create a user-specific profile route instead
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile feature coming soon')),
                        );
                      }
                    },
                    text: AppStrings.profile,
                    icon: Assets.icons.personalInfo.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),

                  //TOdo=====Ask rey (AI)====
                  CustomMenuCard(
                      onTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.pixMatch, extra: userRole);
                      },
                      text: "Ask rey (AI)",
                      icon: Assets.images.alRemovebgPreview.image(
                        height: 20,
                      )),

                  //=========
                  //TOdo=====myFeed====
                  userRole == UserRole.user
                      ? const SizedBox.shrink()
                      : CustomMenuCard(
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
                            ownerProfileController.fetchFollowerOrFollowingData(
                                isFollowers: false);
                            AppRouter.route.pushNamed(RoutePath.followingScreen,
                                extra: {
                                  'userRole': userRole,
                                  'controller': ownerProfileController
                                });
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
                          icon: Assets.images.myBooking.image(),
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
                          ontapYes: () async {
                            await SharePrefsHelper.remove();
                            Get.deleteAll(force: true);
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
