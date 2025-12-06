import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/permission_button/permission_button.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/common_widgets/user_nav_bar/user_nav_bar.dart'
    show CustomNavBar;
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:shimmer/shimmer.dart';
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

    // // Fetch profile data when screen loads
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ownerProfileController.fetchProfileInfo();
    // });

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
      body: Obx(() {
        final isLoading = ownerProfileController.isLoading.value;
        final profileData = ownerProfileController.profileDataList.value;

        return SingleChildScrollView(
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
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 102,
                                  height: 102,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : CustomNetworkImage(
                                boxShape: BoxShape.circle,
                                imageUrl: profileData?.image ??
                                    AppConstants.demoImage,
                                height: 102,
                                width: 102),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.only(top: 8.h),
                                  width: 150.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              )
                            : CustomText(
                                top: 8,
                                text: profileData?.fullName.safeCap() ??
                                    "Loading...",
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.only(top: 8.h),
                                  width: 120.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              )
                            : CustomText(
                                top: 8,
                                text: profileData?.email ?? "",
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.black,
                              ),
                      ],
                    )),

                    //TOdo=====personalInformation====
                    CustomMenuCard(
                      onTap: () {
                        final profileData =
                            ownerProfileController.profileDataList.value;
                        if (profileData != null) {
                          AppRouter.route
                              .pushNamed(RoutePath.personalInfo, extra: {
                            'userRole': userRole,
                            'profileData': profileData,
                            'controller': ownerProfileController,
                          });
                        } else {
                          toastMessage(message: 'Profile data not loaded yet');
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
                              ownerProfileController
                                  .fetchFollowerOrFollowingData(
                                      isFollowers: false);
                              AppRouter.route
                                  .pushNamed(RoutePath.followingScreen, extra: {
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
                    userRole == UserRole.barber
                        ? const SizedBox()
                        : CustomMenuCard(
                            onTap: () {
                              ownerProfileController
                                  .fetchFollowerOrFollowingData(
                                      isFollowers: true);
                              AppRouter.route
                                  .pushNamed(RoutePath.followerScreen, extra: {
                                'userRole': userRole,
                                'controller': ownerProfileController
                              });
                            },
                            text: "My Followers",
                            icon: Assets.icons.flowing.svg(
                              colorFilter: const ColorFilter.mode(
                                  AppColors.black, BlendMode.srcIn),
                            ),
                          ),

                    //TOdo=========

                    userRole == UserRole.user
                        ? CustomMenuCard(
                            onTap: () {
                              final controller = Get.find<UserHomeController>();
                              controller.fetchLoyalityRewards();
                              AppRouter.route
                                  .pushNamed(RoutePath.myLoyality, extra: {
                                'userRole': userRole,
                                'controller': controller,
                              });
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
                              Get.find<UserHomeController>()
                                  .fetchCustomerBookings();
                              AppRouter.route.pushNamed(
                                  RoutePath.customerBookingScreen,
                                  extra: {
                                    'userRole': userRole,
                                    'bookingType': 'Booking',
                                  });
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
        );
      }),
    );
  }
}
