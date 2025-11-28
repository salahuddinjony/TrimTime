import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/view/common_widgets/curved_Banner_clipper/curved_banner_clipper.dart';
import 'package:flutter/material.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart'
    show SafeCap;

class CustomerProfileScreen extends StatelessWidget {
  final String userId;
  final UserRole userRole;
  final controller;

  CustomerProfileScreen(
      {super.key,
      required this.userId,
      required this.userRole,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final dynamic controller = this.controller;
    // Only fetch data if not already loaded
    if (controller.customerInfo.value == null) {
      controller.fetchCustomerInfo(customerId: userId);
    }
    // Clear salon data when navigating back
    return WillPopScope(
      onWillPop: () async {
        controller.customerInfo.value = null;
        return true;
      },
      child: Obx(() {
        final customerData = controller.customerInfo.value;
        final isLoading = controller.customerInfoStatus.value.isLoading;
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(
            appBarBgColor: AppColors.searchScreenBg,
            appBarContent: "Customer Profile",
            iconData: Icons.arrow_back,
            onTap: () {
              // Clear salon data on back navigation , to avoid stale data
              controller.customerInfo.value = null;
              AppRouter.route.pop();
            },
          ),
          body: ClipPath(
            clipper: CurvedBannerClipper(),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.searchScreenBg,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                                text: customerData?.fullName
                                                        .toString()
                                                        .safeCap() ??
                                                    "No Customer Data",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                if (customerData?.isMe ?? false) ...[
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
                                          text: "Your Profile",
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
                                if (!(customerData?.isMe ?? false)) ...[
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
                                                customerData?.id ?? ""),
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.email,
                                              color: AppColors.orange500,
                                              size: 16,
                                            ),
                                            SizedBox(width: 8),
                                            CustomText(
                                              maxLines: 1,
                                              text: customerData?.email ??
                                                  "No email available.",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.black,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
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
                                            text: customerData?.email ??
                                                "No Location",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.gray500,
                                          ),
                                        ],
                                      ),
                                // SizedBox(height: 15.h),
                                // isLoading
                                //     ? Shimmer.fromColors(
                                //         baseColor: Colors.grey[300]!,
                                //         highlightColor: Colors.grey[100]!,
                                //         child: Container(
                                //           width: 100,
                                //           height: 30,
                                //           color: Colors.white,
                                //         ),
                                //       )
                                //     : Row(
                                //         children: [
                                //           GestureDetector(
                                //             onTap: () {
                                //               AppRouter.route.pushNamed(
                                //                   RoutePath.mapViewScreen,
                                //                   extra: userRole);
                                //             },
                                //             child: Container(
                                //               padding: EdgeInsets.all(5.r),
                                //               decoration: BoxDecoration(
                                //                   color: Colors.black,
                                //                   borderRadius:
                                //                       BorderRadius.circular(7)),
                                //               child: Row(
                                //                 children: [
                                //                   const Icon(
                                //                     Icons.location_on,
                                //                     color: Colors.white,
                                //                     size: 10,
                                //                   ),
                                //                   CustomText(
                                //                     left: 5,
                                //                     text: "View",
                                //                     fontSize: 10.sp,
                                //                     fontWeight: FontWeight.w400,
                                //                     color: AppColors.whiteColor,
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(width: 10.w),
                                //           GestureDetector(
                                //             onTap: () {
                                //               _showInformationDialog(
                                //                   context, customerData!);
                                //             },
                                //             child: Container(
                                //               padding: EdgeInsets.all(5.r),
                                //               decoration: BoxDecoration(
                                //                   color: Colors.black,
                                //                   borderRadius:
                                //                       BorderRadius.circular(7)),
                                //               child: Row(
                                //                 children: [
                                //                   CustomText(
                                //                     left: 5,
                                //                     text: "More Info",
                                //                     fontSize: 10.sp,
                                //                     fontWeight: FontWeight.w400,
                                //                     color: AppColors.whiteColor,
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // void _showInformationDialog(
  //     BuildContext context, SingleSaloonModel selonData) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: AppColors.white50,
  //         title: CustomText(
  //           text: "Information",
  //           fontSize: 20.sp,
  //           fontWeight: FontWeight.w400,
  //           color: AppColors.black,
  //         ),
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.person,
  //                   color: AppColors.orange500,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 CustomText(
  //                   text: selonData.shopOwnerName,
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w300,
  //                   color: AppColors.black,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 8.h),
  //             // Row(
  //             //   children: [
  //             //     const Icon(
  //             //       Icons.cake,
  //             //       color: AppColors.orange500,
  //             //     ),
  //             //     const SizedBox(width: 8),
  //             //     CustomText(
  //             //       text: selonData.shopOwnerPhone,
  //             //       fontSize: 16.sp,
  //             //       fontWeight: FontWeight.w300,
  //             //       color: AppColors.black,
  //             //     ),
  //             //   ],
  //             // ),
  //             // SizedBox(height: 8.h),
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.email,
  //                   color: AppColors.orange500,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 CustomText(
  //                   text: selonData.shopOwnerEmail,
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w300,
  //                   color: AppColors.black,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 8.h),
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.phone,
  //                   color: AppColors.orange500,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 CustomText(
  //                   text: selonData.shopOwnerPhone,
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w300,
  //                   color: AppColors.black,
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 8.h),
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.location_on,
  //                   color: AppColors.orange500,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 CustomText(
  //                   text: selonData.shopAddress,
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w300,
  //                   color: AppColors.black,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _customButton(
      String text, IconData icon, controller, bool isFollowing, String userId) {
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
