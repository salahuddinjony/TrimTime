import 'package:barber_time/app/core/bottom_navbar.dart';
import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_hiring_pending_card/custom_hiring_pending_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_info_card/custom_info_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/inner_widgets/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inner_widgets/monitization_date_picar.dart';

class OwnerHomeScreen extends StatelessWidget {
  OwnerHomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final BarberOwnerHomeController controller =
      Get.find<BarberOwnerHomeController>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    final UserRole? userRole = extra is UserRole ? extra : null;

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole,
      ),
      body: Column(
        children: [
          ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡 Appbar💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
          CommonHomeAppBar(
            uniqueQrCode: () {
              AppRouter.route
                  .pushNamed(RoutePath.uniqueQrCode, extra: userRole);
            },
            isDashboard: true,
            onDashboard: () async {
              final Uri url =
                  Uri.parse('https://barber-shift-owner-dashboard.vercel.app/');
              debugPrint("Dashboard button clicked");

              if (await canLaunchUrl(url)) {
                bool launched =
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                if (!launched) {
                  debugPrint(
                      "Failed to launch URL with platformDefault mode, trying externalApplication");
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              } else {
                debugPrint("Could not launch $url");
              }
            },
            onCalender: () {
              debugPrint("Calendar button clicked");
              debugPrint("User Role: ${controller.userRole}");
              if (controller.userRole == "SALOON_OWNER") {
                context.pushNamed(RoutePath.ownerRequestBooking,
                extra: {
                  'userRole': userRole,
                  'controller': controller,
                });
                return;
              }
              AppRouter.route
                  .pushNamed(RoutePath.scheduleScreen, extra: userRole);
            },
            scaffoldKey: scaffoldKey,
            name: "Owener",
            image: AppConstants.demoImage,
            onTap: () {
              AppRouter.route
                  .pushNamed(RoutePath.notificationScreen, extra: userRole);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              // Wrap everything in a SingleChildScrollView
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Obx(
                              () => CustomInfoCard(
                                title: AppStrings.totalCustomer,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller
                                            .dashboardData.value?.totalCustomers
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                image: Assets.images.totalCustomer.image(),
                                onTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.totalCustomerScreen,
                                      extra: userRole);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Obx(
                              () => CustomInfoCard(
                                image: Assets.images.totalBarber.image(),
                                title: AppStrings.totalBarber,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller
                                            .dashboardData.value?.totalBarbers
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                onTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.totalBarber,
                                      extra: userRole);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Obx(
                              () => CustomInfoCard(
                                image: Assets.images.hiringSelected.image(),
                                title: AppStrings.hiringPost,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller
                                            .dashboardData.value?.totalJobPosts
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                onTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.hiringPost,
                                      extra: userRole);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Obx(
                              () => CustomInfoCard(
                                image: Assets.images.barberRequest.image(),
                                title: AppStrings.barberRequest,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller.dashboardData.value
                                            ?.totalJobApplicants
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                onTap: () {
                                  AppRouter.route.pushNamed(
                                      RoutePath.barberRequest,
                                      extra: userRole);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Obx(
                              () => CustomInfoCard(
                                image: Assets.images.pending.image(),
                                title: AppStrings.pending,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller
                                            .dashboardData.value?.totalBookings
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                onTap: () {
                                  context.pushNamed(
                                      RoutePath.ownerRequestBooking,
                                      extra: userRole);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Obx(
                              () => CustomInfoCard(
                                image: Assets.images.waiting.image(),
                                title: AppStrings.waiting,
                                valueWidget: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 40,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      )
                                    : null,
                                value: controller
                                        .dashboardDataStatus.value.isLoading
                                    ? null
                                    : controller.dashboardData.value
                                            ?.totalQueuedBookings
                                            .toString()
                                            .padLeft(2, '0') ??
                                        "00",
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 12.h,
                    ),

                    ///: <<<<<<======✅✅ recentRequest✅✅>>>>>>>>===========
                    CustomTitle(
                      title: AppStrings.recentRequest,
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.recentRequestScreen,
                          extra: {
                          'userRole': userRole,
                          'controller': controller,
                        });
                      },
                      actionColor: AppColors.secondary,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Obx(() {
                      final jobApplicationsList = controller.jobHistoryList
                          .where((job) => job.status.toLowerCase() == 'pending')
                          .toList();
                      if (controller.isJobHistoryLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (jobApplicationsList.isEmpty) {
                        return Center(child: Text('No recent requests found'));
                      }
                      // Barber shop cards
                      return Column(
                        children: List.generate(
                            jobApplicationsList.length > 3
                                ? 3
                                : jobApplicationsList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                // AppRouter.route.pushNamed(RoutePath.visitShop,
                                //     extra: userRole);
                                final barber =
                                    jobApplicationsList[index].barber;
                                // Use userId if available, otherwise use id
                                final barberId = barber.id;
                                debugPrint("Barber ${barber.fullName} clicked");
                                debugPrint("Barber ID: $barberId");

                                // Navigate to professional profile with barber ID
                                AppRouter.route.pushNamed(
                                  RoutePath.professionalProfile,
                                  extra: {
                                    'userRole': userRole,
                                    'barberId': barberId,
                                    'isForActionButton': true,
                                    if (jobApplicationsList[index].status ==
                                        'PENDING') ...{
                                      'onActionApprove': () {
                                        controller.updateJobStatus(
                                            applicationId:
                                                jobApplicationsList[index].id,
                                            status: 'COMPLETED');
                                      },
                                      'onActionReject': () {
                                        controller.updateJobStatus(
                                            applicationId:
                                                jobApplicationsList[index].id,
                                            status: 'REJECTED');
                                      },
                                    },
                                  },
                                );
                              },
                              child: CustomHiringCard(
                                isMessage: true,
                                imageUrl:
                                    jobApplicationsList[index].barber.image ??
                                        '',
                                // Image URL (dynamic)
                                name:
                                    jobApplicationsList[index].barber.fullName,
                                // Dynamic title (Job name)
                                role: jobApplicationsList[index].barber.email,
                                // Hardcoded or dynamic role
                                rating: jobApplicationsList[index]
                                        .jobPost
                                        .shopAverageRating ??
                                    0.0,
                                // Hardcoded or dynamic rating
                                location: jobApplicationsList[index]
                                        .jobPost
                                        .shopAddress ??
                                    '',
                                // Dynamic location or hardcoded
                                onHireTap: () {}, // Hire button action
                              ),
                            ),
                          );
                        }),
                      );
                    }),

                    Row(
                      children: [
                        Obx(() {
                          return Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          controller.dateWiseBookings.length > 0
                                              ? 'You have '
                                              : '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.dateWiseBookings.length >
                                              0
                                          ? '${controller.dateWiseBookings.length.toString().padLeft(2, '0')} '
                                          : '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: controller.dateWiseBookings.length >
                                              0
                                          ? '\nappointments waiting for you!'
                                          : '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        }),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RoutePath.ownerRequestBooking,
                                extra: {
                                  'userRole': userRole,
                                  'controller': controller,
                                });
                          },
                          child: const Text(
                            AppStrings.seeAll,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    HorizontalDatePicker(controller: controller),
                    SizedBox(
                      height: 10.h,
                    ),

                    Obx(() {
                      final data = controller.dateWiseBookings;
                      if (controller.dateWiseBookingsStatus.value.isLoading) {
                        return Center(
                            child: const SizedBox(
                          width: 30,
                          height: 15,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.amber,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                          ),
                        ));
                      }
                      if (data.isEmpty) {
                        return Center(
                            child: Text('No appointments for selected date'));
                      }
                      return Column(
                        children: List.generate(
                            data.length > 2 ? 2 : data.length, (index) {
                          final bookingData = data[index];
                          return ServiceTile(
                            serviceName: bookingData.customerName,
                            serviceTime: bookingData.startTime +
                                " - " +
                                bookingData.endTime,
                            barberName: bookingData.barberName,
                            price: bookingData.totalPrice,
                            imagePath: bookingData.barberImage,
                          );
                        }),
                      );
                    }),
                    SizedBox(
                      height: 10.h,
                    ),

                    ///: <<<<<<======✅✅ Feed✅✅>>>>>>>>===========
                    CustomTitle(
                      title: "Feed",
                      actionText: AppStrings.seeAll,
                      onActionTap: () {
                        AppRouter.route
                            .pushNamed(RoutePath.feedAll, extra: userRole);
                      },
                      actionColor: AppColors.secondary,
                    ),

                    SizedBox(
                      height: 12.h,
                    ),
                    Obx(() {
                      final feeds = controller.homeFeedsList;
                      if (controller.getFeedsStatus.value.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (feeds.isEmpty) {
                        return Center(child: Text('No feeds available'));
                      }
                      return Column(
                        children: feeds
                            .take(feeds.length > 4 ? 4 : feeds.length)
                            .map((feed) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Column(
                              children: [
                                CustomFeedCard(
                                  isFavouriteFromApi: feed.isFavorite ?? false,
                                  isVisitShopButton: feed.saloonOwner != null,
                                  favoriteCount: feed.favoriteCount.toString(),
                                  userImageUrl:
                                      feed.userImage ?? AppConstants.demoImage,
                                  userName: feed.userName,
                                  userAddress:
                                      feed.saloonOwner?.shopAddress ?? '',
                                  postImageUrl: feed.images.isNotEmpty
                                      ? feed.images.first
                                      : AppConstants.demoImage,
                                  postText: feed.caption,
                                  rating: feed.saloonOwner != null
                                      ? "${feed.saloonOwner!.avgRating} ★ (${feed.saloonOwner!.ratingCount})"
                                      : "",
                                  onFavoritePressed: (isFavorite) {
                                    controller.toggleLikeFeed(
                                      feedId: feed.id,
                                      isUnlike: isFavorite == true,
                                    );
                                  },
                                  onVisitShopPressed: () {
                                    if (feed.saloonOwner != null) {
                                      // controller.getSelonData(
                                      //     userId:
                                      //         feed.saloonOwner!.userId);
                                      AppRouter.route.pushNamed(
                                        RoutePath.shopProfileScreen,
                                        extra: {
                                          'userRole': userRole,
                                          'userId': feed.saloonOwner!.userId,
                                          'controller': controller,
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: 30.h),

                    // CustomTitle(
                    //   title: "Feed",
                    //   actionText: AppStrings.seeAll,
                    //   onActionTap: () {
                    //     AppRouter.route
                    //         .pushNamed(RoutePath.feedAll, extra: userRole);
                    //   },
                    //   actionColor: AppColors.secondary,
                    // ),

                    // SizedBox(
                    //   height: 12.h,
                    // ),

                    // // Feed Cards Section
                    // // Column(
                    // //   children: List.generate(4, (index) {
                    // //     return CustomFeedCard(
                    // //       userImageUrl: AppConstants.demoImage,
                    // //       userName: "Roger Hunt",
                    // //       userAddress:
                    // //           "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                    // //       postImageUrl: AppConstants.demoImage,
                    // //       postText:
                    // //           "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence!#BarberLife #StayFresh",
                    // //       rating: "5.0 * (169)",
                    // //       onFavoritePressed: () {
                    // //         // Handle favorite button press
                    // //       },
                    // //       onVisitShopPressed: () {
                    // //         AppRouter.route.pushNamed(RoutePath.shopProfileScreen,
                    // //             extra: userRole);
                    // //         // Handle visit shop button press
                    // //       },
                    // //     );
                    // //   }),
                    // // ),

                    // Column(
                    //   children: List.generate(4, (index) {
                    //     final postUrl = index == 0
                    //         ? AppConstants.demoImage
                    //         : "https://www.youtube.com/watch?v=vE4jYKyv_GM"; // YouTube ভিডিও URL

                    //     return Padding(
                    //       padding: EdgeInsets.only(bottom: 12.h),
                    //       child: CustomFeedCard(
                    //         userImageUrl: AppConstants.demoImage,
                    //         userName: "Roger Hunt",
                    //         userAddress: "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                    //         postImageUrl: postUrl,
                    //         postText: "Fresh Cut, Fresh Start! 🔥💈 Kickstart your day with confidence! #BarberLife #StayFresh",
                    //         rating: "5.0 ★ (169)",
                    //         onFavoritePressed: (isFavorite) {
                    //           // Handle favorite button press
                    //         },
                    //         onVisitShopPressed: () => AppRouter.route.pushNamed(
                    //           RoutePath.shopProfileScreen,
                    //           extra: userRole,
                    //         ),
                    //       ),
                    //     );
                    //   }),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
