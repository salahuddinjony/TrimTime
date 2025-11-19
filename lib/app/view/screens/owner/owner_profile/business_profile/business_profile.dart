import 'package:shimmer/shimmer.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../../common_widgets/common_profile_card/common_profile_card.dart';
import '../../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class BusinessProfile extends StatelessWidget {
  final UserRole userRole;
  final OwnerProfileController controller;

  const BusinessProfile(
      {super.key, required this.userRole, required this.controller});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map && extra['userRole'] is UserRole) {
      userRole = extra['userRole'] as UserRole;
    } else {
      userRole = null;
    }
    return Scaffold(
        // bottomNavigationBar: BottomNavbar(
        //   currentIndex: 4,
        //   role: userRole ?? this.userRole,
        // ),
        backgroundColor: AppColors.linearFirst,
        //==================✅✅Header✅✅===================
        appBar: const CustomAppBar(
          appBarBgColor: AppColors.linearFirst,
          appBarContent: "Shop Profile",
          iconData: Icons.arrow_back,
        ),
        body: ClipPath(
          clipper: CurvedBannerClipper(),
          child: Container(
            width: double.infinity,
            // Removed fixed height to allow content to extend fully
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCCEDC4AC), // First color (with opacity)
                  Color(0xFFE9864E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Obx(() {
                final data = controller.businessProfileData.value;
                if (data == null) {
                  // SHIMMER LOADING UI
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Card Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Total Cards Shimmer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (i) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    width: 80,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Barbers Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: double.infinity,
                              height: 24,
                              margin: const EdgeInsets.only(bottom: 10),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              separatorBuilder: (c, i) => SizedBox(width: 14),
                              itemBuilder: (c, i) => Column(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 50,
                                      height: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Gallery Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 120,
                              height: 20,
                              margin: const EdgeInsets.only(bottom: 10),
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              3,
                              (i) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 96,
                                  height: 78,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              3,
                              (i) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 96,
                                  height: 78,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Services Shimmer
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 140,
                              height: 20,
                              margin: const EdgeInsets.only(bottom: 10),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 48,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              separatorBuilder: (c, i) => SizedBox(width: 8),
                              itemBuilder: (c, i) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 80,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  );
                }
                // REAL DATA UI
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonProfileCard(
                          name: data.shopName,
                          bio: data.shopBio,
                          imageUrl: data.shopLogo,
                          onEditTap: () {
                            AppRouter.route.pushNamed(
                              RoutePath.businessProfileEdit,
                              extra: userRole,
                            );
                          },
                          userRole: userRole,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            //==================✅✅Total Card✅✅===================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("");
                                    AppRouter.route.pushNamed(
                                        RoutePath.rateScreen,
                                        extra: userRole);
                                  },
                                  child: CommonProfileTotalCard(
                                      title: AppStrings.ratings,
                                      value: data.ratingCount
                                          .toString()
                                          .padLeft(2, '0')),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    print("");
                                    // AppRouter.route.pushNamed(
                                    //     RoutePath.followingScreen,
                                    //     extra: userRole);
                                  },
                                  child: CommonProfileTotalCard(
                                      title: AppStrings.following,
                                      value: data.followingCount
                                          .toString()
                                          .padLeft(2, '0')),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    print("");
                                    // AppRouter.route.pushNamed(
                                    //     RoutePath.followerScreen,
                                    //     extra: userRole);
                                  },
                                  child: CommonProfileTotalCard(
                                      title: "Follower",
                                      value: data.followerCount
                                          .toString()
                                          .padLeft(2, '0')),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Row(
                              children: [
                                const CustomText(
                                  text: 'All Barber',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                  bottom: 10,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.route.pushNamed(
                                        RoutePath.barberAddedScreen,
                                        extra: userRole);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    AppRouter.route.pushNamed(
                                        RoutePath.barberAddedScreen,
                                        extra: userRole);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            SizedBox(
                              height: 100.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.barbers.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 14.w),
                                itemBuilder: (context, index) {
                                  final barber = data.barbers[index];
                                  return Column(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: barber.image,
                                        height: 70,
                                        width: 70,
                                        boxShape: BoxShape.circle,
                                      ),
                                      SizedBox(height: 6.h),
                                      CustomText(
                                        text: barber.fullName,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                        bottom: 10,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const CustomText(
                              top: 18,
                              text: 'Photo Gallery',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white50,
                              bottom: 10,
                            ),
                            data.shopImages.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10.h,
                                        crossAxisSpacing: 10.w,
                                        childAspectRatio: 96 / 78,
                                      ),
                                      itemCount: data.shopImages.length,
                                      itemBuilder: (context, index) {
                                        return CustomNetworkImage(
                                          imageUrl: data.shopImages[index],
                                          height: 78,
                                          width: 96,
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: const Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Color.fromARGB(
                                              255, 119, 117, 117),
                                        ),
                                        CustomText(
                                          text: 'No images available',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(
                                              255, 114, 112, 112),
                                        ),
                                      ],
                                    ),
                                  ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 10.h,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //     CustomNetworkImage(
                            //         imageUrl: AppConstants.demoImage,
                            //         height: 78,
                            //         width: 96),
                            //   ],
                            // ),
                            data.services.isNotEmpty == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        top: 18,
                                        text: 'Services Offered',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.white50,
                                        bottom: 10,
                                      ),
                                      SizedBox(
                                        height:
                                            48, // Adjust height as needed for horizontal chips
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.services.length,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(width: 8),
                                          itemBuilder: (context, index) {
                                            final service =
                                                data.services[index];
                                            return Chip(
                                              label: CustomText(
                                                text: service.serviceName,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black,
                                              ),
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ));
  }
}
