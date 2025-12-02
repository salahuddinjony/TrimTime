import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/common_msg_and_follow_button.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_card/common_follow_msg_button.dart/custom_booking_button.dart';
import 'package:barber_time/app/view/common_widgets/common_profile_total_card/common_profile_total_card.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/view_image_gallery/widgets/design_files_gallery.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/models/selon_model/single_selon_model.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/widgets/rating_dialog.dart';
import 'package:barber_time/app/view/screens/common_screen/shop_profile/widgets/services_card.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';

class ShopProfileScreen<T> extends StatelessWidget {
  final String userId;
  final UserRole userRole;
  final T controller;
  final bool isShowOwnerInfo;

  ShopProfileScreen(
      {super.key,
      required this.userId,
      required this.userRole,
      this.isShowOwnerInfo = true,
      required this.controller});

  // BarberHomeController get controller {
  //   // Initialize or get the controller with the userId tag
  //   if (Get.isRegistered<BarberHomeController>(tag: userId)) {
  //     return Get.find<BarberHomeController>(tag: userId);
  //   } else {
  //     final ctrl = Get.put(BarberHomeController(), tag: userId);
  //     // Fetch salon data once when controller is created
  //     ctrl.getSelonData(userId: userId);
  //     // Don't set isFollowing here - wait for data to load
  //     // ctrl.isFollowing.value will be updated after data fetch completes

  //     return ctrl;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final dynamic controller = this.controller;
    // Only fetch data if not already loaded
    if (controller.selonList.value == null) {
      controller.getSelonData(userId: userId);
    }
    // Clear salon data when navigating back
    return WillPopScope(
      onWillPop: () async {
        controller.selonList.value = null;
        return true;
      },
      child: Obx(() {
        final selonData = controller.selonList.value;

        // // Only update isFollowing after a successful fetch, not on every rebuild or button click
        // if (controller.getSelonStatus.value.isSuccess &&
        //     controller.selonList.value != null &&
        //     controller.getSelonStatus.value == RxStatus.success() &&
        //     ModalRoute.of(context)?.isCurrent == true) {
        //   controller.isFollowing.value = controller.selonList.value!.isFollowing;
        // }

        final isLoading = controller.getSelonStatus.value.isLoading;
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            appBarBgColor: AppColors.searchScreenBg,
            appBarContent: "Shop Profile",
            iconData: Icons.arrow_back,
            onTap: () {
              // Clear salon data on back navigation , to avoid stale data
              controller.selonList.value = null;
              AppRouter.route.pop();
            },
          ),
          body: Stack(
            children: [
              // Curved banner background
              ClipPath(
                clipper: CurvedBannerClipper(),
                child: Container(
                  height: 600.h,
                  decoration: const BoxDecoration(
                    color: AppColors.searchScreenBg,
                  ),
                ),
              ),
              // Content on top
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop Owner Card (centered)
                      if (isShowOwnerInfo)
                        Center(
                          child: Card(
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: const Color.fromARGB(255, 92, 168, 182)
                                    .withValues(alpha: .1),
                                width: 5,
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 100,
                                            height: 18,
                                            color: Colors.white,
                                          ),
                                        )
                                      : CustomText(
                                          text: selonData?.shopOwnerName ??
                                              'No Owner Data',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  SizedBox(height: 4.h),
                                  isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 60,
                                            height: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      : CustomText(
                                          text: "Shop Owner",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.gray500,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 60),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: .1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 50.h),
                                isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 120,
                                          height: 22,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                text: selonData?.shopName ??
                                                    "No Shop Data",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.black,
                                              ),
                                              SizedBox(width: 6.w),
                                              Icon(
                                                selonData?.isVerified ?? false
                                                    ? Icons.verified
                                                    : Icons.cancel,
                                                color: selonData?.isVerified ??
                                                        false
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                if (selonData?.isMe ?? false) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                              255, 143, 115, 115)
                                          .withValues(alpha: .08),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 177, 150, 150)
                                              .withValues(alpha: .18)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_user_rounded,
                                            size: 18,
                                            color: const Color.fromARGB(
                                                255, 163, 112, 112)),
                                        const SizedBox(width: 8),
                                        CustomText(
                                          text: "Your Shop Profile",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              255, 141, 102, 102),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                if (!(selonData?.isMe ?? false)) ...[
                                  isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 80,
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _customButton(
                                                controller.isFollowing.value
                                                    ? "Unfollow"
                                                    : "Follow",
                                                controller.isFollowing.value
                                                    ? Icons.person_remove
                                                    : Icons.person_add,
                                                controller,
                                                controller.isFollowing.value,
                                                selonData?.userId ?? ""),
                                            const SizedBox(width: 10),
                                            _iconButton(Assets
                                                .images.chartSelected
                                                .image(
                                              color: Colors.white,
                                              height: 15,
                                            )),
                                          ],
                                        ),
                                  const SizedBox(height: 20),
                                ],
                                isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: double.infinity,
                                          height: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: CustomText(
                                          maxLines: 20,
                                          text: selonData?.shopBio ??
                                              "No shop bio available.",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.black,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                SizedBox(height: 15.h),
                                isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 120,
                                          height: 18,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: AppColors.orange500,
                                            size: 14,
                                          ),
                                          CustomText(
                                            left: 5,
                                            text: selonData?.shopAddress ??
                                                "No Location",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.gray500,
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 15.h),
                                isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              AppRouter.route.pushNamed(
                                                  RoutePath.mapViewScreen,
                                                  extra: userRole);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.r),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                  CustomText(
                                                    left: 5,
                                                    text: "View",
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () {
                                              _showInformationDialog(
                                                  context, selonData!);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.r),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                    left: 5,
                                                    text: "More Info",
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : CustomNetworkImage(
                                    imageUrl: AppConstants.shop,
                                    height: 100,
                                    width: 100,
                                    boxShape: BoxShape.circle,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Rating Badge Section
                      if (selonData != null &&
                          selonData.ratingCount > 0 &&
                          !isLoading)
                        GestureDetector(
                          onTap: () {
                            controller.getBarberReviews(
                                userId: selonData.userId);
                            context.pushNamed(
                              RoutePath.reviewsScreen,
                              extra: {
                                'userRole': userRole,
                                'userId': selonData.userId,
                                'controller': controller,
                                'salonName': selonData.shopName,
                              },
                            );
                            debugPrint("Rating badge clicked");
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.orange500.withValues(alpha: .15),
                                    AppColors.last.withValues(alpha: .1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      AppColors.orange500.withValues(alpha: .3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text:
                                        selonData.avgRating.toStringAsFixed(1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                  SizedBox(width: 6.w),
                                  CustomText(
                                    text:
                                        "(${selonData.ratingCount} ${selonData.ratingCount == 1 ? 'review' : 'reviews'})",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    3,
                                    (index) => Container(
                                          width: 80,
                                          height: 40,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          color: Colors.white,
                                        )),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonProfileTotalCard(
                                  title: AppStrings.ratings,
                                  value: selonData != null
                                      ? "${selonData.ratingCount}"
                                      : "0",
                                ),
                                const SizedBox(width: 8),
                                CommonProfileTotalCard(
                                  title: AppStrings.following,
                                  value: selonData != null
                                      ? "${selonData.followingCount}"
                                      : "0",
                                ),
                                const SizedBox(width: 8),
                                CommonProfileTotalCard(
                                  title: "Follower",
                                  value: selonData != null
                                      ? "${selonData.followerCount}"
                                      : "0",
                                ),
                              ],
                            ),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 120,
                                height: 24,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.white,
                              ),
                            )
                          : const CustomText(
                              top: 10,
                              bottom: 8,
                              text: "All Barbers",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Row(
                                children: List.generate(
                                    4,
                                    (index) => Container(
                                          width: 58,
                                          height: 58,
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        )),
                              ),
                            )
                          : selonData?.barbers.isEmpty == true
                              ? Container(
                                  child: CustomText(
                                    text: "No barbers available.",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray500,
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        selonData?.barbers.length ?? 0,
                                        (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                final barber =
                                                    selonData?.barbers[index];
                                                if (barber != null) {
                                                  // Use userId if available, otherwise use id
                                                  final barberId =
                                                      barber.userId ??
                                                          barber.id;
                                                  debugPrint(
                                                      "Barber ${barber.fullName} clicked");
                                                  debugPrint(
                                                      "Barber ID: $barberId");

                                                  // Navigate to professional profile with barber ID
                                                  AppRouter.route.pushNamed(
                                                    RoutePath
                                                        .professionalProfile,
                                                    extra: {
                                                      'userRole': userRole,
                                                      'barberId': barberId,
                                                    },
                                                  );
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: CustomNetworkImage(
                                                        imageUrl: selonData
                                                                ?.barbers[index]
                                                                .image ??
                                                            AppConstants
                                                                .demoImage,
                                                        height: 58.h,
                                                        boxShape:
                                                            BoxShape.circle,
                                                        width: 58.h),
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  CustomText(
                                                    text: selonData
                                                            ?.barbers[index]
                                                            .fullName ??
                                                        "No Name",
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                      const SizedBox(height: 10),
                      if (selonData != null &&
                              selonData.shopImages.isNotEmpty ||
                          isLoading) ...[
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 120,
                                  height: 24,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  color: Colors.white,
                                ),
                              )
                            : const CustomText(
                                top: 10,
                                bottom: 8,
                                text: "Shop Images",
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 80,
                                      margin: const EdgeInsets.all(8),
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: 100.w,
                                height: 100.h,
                                child: DesignFilesGallery(
                                  designFiles: selonData?.shopImages.map((e) {
                                    return e;
                                  }).toList(),
                                  height: 100.h,
                                  width: double.infinity,
                                ),
                              ),
                        SizedBox(height: 20.h)
                      ],
                      // Services Section
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 120,
                                height: 24,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: Colors.white,
                              ),
                            )
                          : const CustomText(
                              top: 10,
                              bottom: 8,
                              text: "Services",
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                      2,
                                      (index) => Container(
                                            width: 200,
                                            height: 120,
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          )),
                                ),
                              ),
                            )
                          : selonData?.services.isEmpty == true
                              ? Container(
                                  child: CustomText(
                                    text: "No services available.",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.gray500,
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        selonData?.services.length ?? 0,
                                        (index) {
                                      final service =
                                          selonData!.services[index];
                                      return ServicesCard(
                                        serviceName: service.serviceName,
                                        price: service.price,
                                        duration: service.duration,
                                        isActive: service.isActive,
                                      );
                                    }),
                                  ),
                                ),
                      const SizedBox(height: 10),
                      // isLoading
                      //     ? Shimmer.fromColors(
                      //         baseColor: Colors.grey[300]!,
                      //         highlightColor: Colors.grey[100]!,
                      //         child: Container(
                      //           width: 120,
                      //           height: 24,
                      //           margin:
                      //               const EdgeInsets.symmetric(vertical: 10),
                      //           color: Colors.white,
                      //         ),
                      //       )
                      //     : const CustomText(
                      //         top: 10,
                      //         text: 'Gallery',
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.w600,
                      //         color: AppColors.gray500,
                      //         bottom: 10,
                      //       ),
                      // isLoading
                      //     ? Shimmer.fromColors(
                      //         baseColor: Colors.grey[300]!,
                      //         highlightColor: Colors.grey[100]!,
                      //         child: Container(
                      //           width: 96,
                      //           height: 78,
                      //           color: Colors.white,
                      //         ),
                      //       )
                      //     : CustomNetworkImage(
                      //         imageUrl: AppConstants.demoImage,
                      //         height: 78,
                      //         width: 96),
                      // const SizedBox(height: 20),
                      // isLoading
                      //     ? Shimmer.fromColors(
                      //         baseColor: Colors.grey[300]!,
                      //         highlightColor: Colors.grey[100]!,
                      //         child: Container(
                      //           width: MediaQuery.of(context).size.width / 2,
                      //           height: 40,
                      //           margin:
                      //               const EdgeInsets.symmetric(vertical: 10),
                      //           color: Colors.white,
                      //         ),
                      //       )
                      //     : Center(
                      //         child: CustomButton(
                      //           width: MediaQuery.of(context).size.width / 2,
                      //           fillColor: AppColors.last,
                      //           borderColor: Colors.white,
                      //           textColor: Colors.white,
                      //           onTap: () {
                      //             RatingDialog.showRatingDialog<T>(context, controller: controller);
                      //           },
                      //           title: AppStrings.addReview,
                      //         ),
                      //       ),

                      // Booking Button Section
                      if (userRole == UserRole.user &&
                          !isShowOwnerInfo &&
                          selonData?.services.isNotEmpty == true &&
                          selonData?.barbers.isNotEmpty == true) ...[
                        const SizedBox(height: 20),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 48.h,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : CustomBookingButton(
                                onTap: () {
                                  debugPrint("Booking button tapped");

                                  controller.clearSeloonBookingFields();

                                  // fetch selon services
                                  controller.fetchSelonServices(
                                      userId: selonData!.userId);

                                  AppRouter.route.pushNamed(
                                    RoutePath.seloonBookingScreen,
                                    extra: {
                                      'userRole': userRole,
                                      'userId': selonData!.userId,
                                      'controller': controller,
                                      'seloonName': selonData.shopName,
                                      'seloonImage': selonData.shopLogo,
                                      'seloonAddress': selonData.shopAddress,
                                    },
                                  );

                                  // get barber with date
                                  controller.getbarberWithDate(
                                      barberId: selonData!.userId,
                                      date: intl.DateFormat('yyyy-MM-dd')
                                          .format(controller.selectedDate));
                                },
                              ),
                      ],

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showInformationDialog(
      BuildContext context, SingleSaloonModel selonData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white50,
          title: CustomText(
            text: "Information",
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: selonData.shopOwnerName,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Row(
              //   children: [
              //     const Icon(
              //       Icons.cake,
              //       color: AppColors.orange500,
              //     ),
              //     const SizedBox(width: 8),
              //     CustomText(
              //       text: selonData.shopOwnerPhone,
              //       fontSize: 16.sp,
              //       fontWeight: FontWeight.w300,
              //       color: AppColors.black,
              //     ),
              //   ],
              // ),
              // SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: selonData.shopOwnerEmail,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: selonData.shopOwnerPhone,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.orange500,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: selonData.shopAddress,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _customButton(String text, IconData icon, T controller,
      bool isFollowing, String userId) {
    return GestureDetector(
      onTap: () {
        final dynamic controller = this.controller;
        controller.toggleFollow(userId: userId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            CustomText(
              text: text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(Widget icon) {
    return GestureDetector(
      onTap: () {
        AppRouter.route.pushNamed(RoutePath.chatScreen);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon,
      ),
    );
  }
}
