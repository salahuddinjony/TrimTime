import 'package:barber_time/app/core/bottom_navbar.dart';
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
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widgets/custom_menu_card/custom_menu_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });
  // final InfoController infoController = Get.find<InfoController>();
  final OwnerProfileController ownerProfileController =
      Get.find<OwnerProfileController>();
  @override
  Widget build(BuildContext context) {
    // state.extra may be passed as a UserRole or as a Map (from other navigations).
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map) {
      // Some navigations pass a Map with a 'userRole' field.
      try {
        userRole = extra['userRole'] as UserRole?;
      } catch (_) {
        userRole = null;
      }
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      // Only show the floatingActionButton if the role is 'user'
      // floatingActionButton: userRole == UserRole.user
      //     ? IconButton(
      //         onPressed: () {
      //           AppRouter.route
      //               .pushNamed(RoutePath.scannerScreen, extra: userRole);
      //         },
      //         icon: Container(
      //           height: 85,
      //           width: 85,
      //           padding: EdgeInsets.all(12.r),
      //           // You can adjust the padding as needed
      //           decoration: const BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: AppColors.navColor, // Custom color for the button
      //           ),
      //           child: Assets.images.bxScan
      //               .image(color: AppColors.black), // Scanner icon
      //         ),
      //       )
      //     : null,
      // // Return null if the role is not 'user'
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavbar(
        currentIndex: 4,
        role: userRole,
      ),

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
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(child: Obx(() {
                    final data = ownerProfileController.profileDataList;
                    if (ownerProfileController.isLoading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Column(
                          children: [
                            Container(
                              width: 102,
                              height: 102,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 140,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 180,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    }
                    if (data.isEmpty) {
                      return const Text('No profile data');
                    }
                    return Column(
                      children: [
                        Obx(() {
                          // Prefer controller's picked image (local path) when available.
                          final currentData =
                              ownerProfileController.profileDataList.first;
                          final imageUrl =
                              ownerProfileController.imagepath.value.isNotEmpty
                                  ? ownerProfileController.imagepath.value
                                  : (currentData.image != null &&
                                          currentData.image!.isNotEmpty
                                      ? currentData.image!
                                      : AppConstants.demoImage);
                          final isNetwork =
                              ownerProfileController.isNetworkImage.value;
                          return CustomNetworkImage(
                              boxShape: BoxShape.circle,
                              imageUrl: imageUrl,
                              height: 102,
                              width: 102,
                              isFile: !isNetwork);
                        }),
                        CustomText(
                          top: 8,
                          text: data.first.fullName.safeCap(),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                        CustomText(
                          top: 8,
                          text: data.first.email,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.black,
                        ),
                      ],
                    );
                  })),
                  SizedBox(
                    height: 30.h,
                  ),
                  //TOdo=====personalInformation====
                  CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.personalInfo, extra: {
                        'userRole': userRole,
                        'profileData':
                            ownerProfileController.profileDataList.first,
                        'controller': ownerProfileController
                      });
                    },
                    text: AppStrings.personalInformation,
                    icon: Assets.icons.personalInfo.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  ),

                  //TOdo=====Professional Profile====
                  userRole == UserRole.barber
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(
                                RoutePath.professionalProfile,
                                extra: {
                                  'userRole': userRole,
                                  'profileData': ownerProfileController
                                      .profileDataList.first,
                                  'controller': ownerProfileController
                                });
                          },
                          text: AppStrings.professionalProfile,
                          icon: Assets.icons.personalInfo.svg(
                            colorFilter: const ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),

                  //TOdo=====businessProfile====
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.businessProfile,
                                extra: userRole);
                          },
                          text: AppStrings.businessProfile,
                          icon: Assets.icons.business.svg(
                            colorFilter: const ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),
                  //TOdo=====jobPost====
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route
                                .pushNamed(RoutePath.jobPost, extra: userRole);
                          },
                          text: AppStrings.jobPost,
                          icon: Assets.icons.job.svg(
                            colorFilter: const ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),

                  //TOdo=========
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.rateScreen,
                                extra: userRole);
                          },
                          text: AppStrings.rating,
                          icon: Assets.icons.rate.svg(
                            colorFilter: const ColorFilter.mode(
                                AppColors.black, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),

                  //chat=========
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.inboxScreen,
                                extra: userRole);
                          },
                          text: AppStrings.chat,
                          icon: Assets.images.chartSelected.image(),

                        )
                      : const SizedBox(),

                  //chat=========
                  userRole == UserRole.user
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.inboxScreen,
                                extra: userRole);
                          },
                          text: AppStrings.chat,
                          icon: Assets.images.chartSelected.image(),
                        )
                      : const SizedBox(),
                  //TOdo=====barber====
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.hiringBarber,
                                extra: userRole);
                          },
                          text: AppStrings.barber,
                          icon: Assets.images.berber
                              .image(height: 20, color: Colors.black),
                        )
                      : const SizedBox(),

                  //TOdo=====Payment====
                  userRole == UserRole.owner
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.ownerPayment,
                                extra: userRole);
                          },
                          text: "Payment",
                          icon: Assets.images.hugeiconsPayment02
                              .image(height: 20, color: Colors.black),
                        )
                      : const SizedBox(),

                  //TOdo=====myFeed====
                  // userRole == UserRole.user
                  //     ? const SizedBox.shrink()
                  //     :
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

                  //TOdo=====favorite====

                  userRole == UserRole.barber
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(
                                RoutePath.myFavoriteScreen,
                                extra: userRole);
                          },
                          text: AppStrings.myFavorite,
                          icon: Assets.images.savedUnselected
                              .image(height: 16, color: AppColors.gray500),
                        )
                      : const SizedBox(),

                  //TOdo=====  ====

                  userRole == UserRole.barber
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.paymentOption,
                                extra: userRole);
                          },
                          text: "withdraw money",
                          icon: Assets.images.withdrawMoney.svg())
                      : const SizedBox(),

                  //TOdo=====rating====

                  userRole == UserRole.barber
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.rateScreen,
                                extra: userRole);
                          },
                          text: AppStrings.ratings,
                          icon: Assets.icons.rate.svg(
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                AppColors.gray500, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),

                  //TOdo=========

                  userRole == UserRole.barber
                      ? CustomMenuCard(
                          onTap: () {
                            AppRouter.route.pushNamed(RoutePath.barberQueScreen,
                                extra: userRole);
                          },
                          text: AppStrings.que,
                          icon: Assets.icons.ques.svg(
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                AppColors.gray500, BlendMode.srcIn),
                          ),
                        )
                      : const SizedBox(),

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
                        ),  //TOdo=====following====


                  userRole == UserRole.owner
                      ? CustomMenuCard(
                    onTap: () {
                      AppRouter.route.pushNamed(RoutePath.followerScreen,
                          extra: userRole);
                    },
                    text: "My Followers",
                    icon: Assets.icons.flowing.svg(
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn),
                    ),
                  )  : const SizedBox(),


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
                            debugPrint("Log Out");

                            await SharePrefsHelper.remove();
                            Get.deleteAll(
                                force:
                                    true); //its indicates to clear all controllers before navigating
                            context.goNamed(RoutePath.signInScreen);
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
