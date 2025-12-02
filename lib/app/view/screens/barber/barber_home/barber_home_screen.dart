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
import 'package:barber_time/app/view/common_widgets/custom_border_card/custom_border_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class BarberHomeScreen extends StatelessWidget {
  BarberHomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final BarberHomeController controller = Get.find<BarberHomeController>();
  final OwnerProfileController profileController =
      Get.find<OwnerProfileController>();

  @override
  Widget build(BuildContext context) {
    // Handle both direct UserRole and Map containing userRole
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map<String, dynamic>) {
      userRole = extra['userRole'] as UserRole?;
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: 0,
        role: userRole,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ///: <<<<<<======🗄️🗄️🗄️🗄️🗄️🗄️💡💡 Appbar💡💡🗄️🗄️🗄️🗄️🗄️🗄️🗄️>>>>>>>>===========
            Obx(() {
              final hasProfile =
                  profileController.profileDataList.value != null;
              if (!hasProfile) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      // Shimmer for circular profile image
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Shimmer for name and subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 160.w,
                                height: 14.h,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 100.w,
                                height: 10.h,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Calendar and notification icons keep their actions
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          AppRouter.route.pushNamed(RoutePath.scheduleScreen,
                              extra: userRole);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          AppRouter.route.pushNamed(
                              RoutePath.notificationScreen,
                              extra: userRole);
                        },
                      ),
                    ],
                  ),
                );
              }

              // When profile data is available show the regular app bar
              final profile = profileController.profileDataList.value!;
              return CommonHomeAppBar(
                onCalender: () {
                  AppRouter.route
                      .pushNamed(RoutePath.scheduleScreen, extra: userRole);
                },
                isCalender: true,
                scaffoldKey: scaffoldKey,
                name: profile.fullName,
                image: profile.image ?? '',
                onTap: () {
                  AppRouter.route
                      .pushNamed(RoutePath.notificationScreen, extra: userRole);
                },
              );
            }),
            Expanded(
              child: SingleChildScrollView(
                // Wrap everything in a SingleChildScrollView
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      ///: <<<<<<======✅✅ job post✅✅>>>>>>>>===========
                      CustomTitle(
                        title: AppStrings.jobPost,
                        actionText: AppStrings.seeAll,
                        onActionTap: () {
                          AppRouter.route
                              .pushNamed(RoutePath.jobPostAll, extra: userRole);
                        },
                        actionColor: AppColors.secondary,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      // Barber shop cards
                      Obx(() {
                        if (controller.jobPostList.isEmpty) {
                          // Show a nice "No Job Post" UI when there are no job posts from API
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 32.h),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.images.logo.image(height: 60),
                                SizedBox(height: 16.h),
                                Text(
                                  "No Job Post",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Currently, there are no job posts available.\nPlease check back later.",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: List.generate(
                            controller.jobPostList.length > 2
                                ? 2
                                : controller.jobPostList.length,
                            (index) {
                              final job = controller.jobPostList[index];

                              // Format salary / price
                              final salary = job.salary != null
                                  ? '£${job.salary.toString()}'
                                  : '£20.00/Per hr';

                              // Format dates (show start - end if available)
                              String dateText = '';
                              if (job.startDate != null &&
                                  job.endDate != null) {
                                final start = job.startDate;
                                final end = job.endDate;
                                dateText =
                                    '${start!.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year} - '
                                    '${end!.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
                              } else if (job.datePosted != null) {
                                final posted = job.datePosted;
                                dateText =
                                    '${posted!.day.toString().padLeft(2, '0')}/${posted.month.toString().padLeft(2, '0')}/${posted.year}';
                              } else {
                                dateText = '—';
                              }

                              // Logo image: prefer remote shopLogo, fallback to asset logo
                              final logoWidget = (job.shopLogo?.isNotEmpty ==
                                      true)
                                  ? CachedNetworkImage(
                                      imageUrl: job.shopLogo!,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Assets.images.logo.image(height: 50),
                                    )
                                  : Assets.images.logo.image(height: 50);

                              return CustomBorderCard(
                                title: job.shopName ?? 'Barber Shop',
                                time: '10:00am-10:00pm',
                                price: salary,
                                date: dateText,
                                buttonText: 'Apply',
                                isButton: true,
                                isSeeDescription: true,
                                onButtonTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Apply for Job'),
                                      content: Text(
                                          'Apply to ${job.shopName ?? 'this shop'}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller.applyJob(
                                                jobId: job.id ?? '');
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Application sent to ${job.shopName ?? 'shop'}')),
                                            );
                                          },
                                          child: const Text('Apply'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                logoImage: logoWidget,
                                seeDescriptionTap: () {
                                  final desc = job.description ??
                                      'No description available';
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                          job.shopName ?? 'Job Description'),
                                      content: SingleChildScrollView(
                                          child: Text(desc)),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }),

                      ///: <<<<<<======✅✅ Feed✅✅>>>>>>>>===========

                      CustomTitle(
                        title: "Feed",
                        actionText: AppStrings.seeAll,
                        onActionTap: () {
                          AppRouter.route.pushNamed(RoutePath.feedAll, extra: {
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
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Column(
                                children: [
                                  Obx(() {
                                    final currentFeed =
                                        controller.homeFeedsList[index];
                                    return CustomFeedCard(
                                      isFavouriteFromApi:
                                          currentFeed.isFavorite ?? false,
                                      isVisitShopButton:
                                          currentFeed.saloonOwner != null,
                                      favoriteCount:
                                          currentFeed.favoriteCount.toString(),
                                      userImageUrl: currentFeed.userImage ??
                                          AppConstants.demoImage,
                                      userName: currentFeed.userName,
                                      userAddress: currentFeed
                                              .saloonOwner?.shopAddress ??
                                          '',
                                      postImageUrl:
                                          currentFeed.images.isNotEmpty
                                              ? currentFeed.images.first
                                              : AppConstants.demoImage,
                                      postText: currentFeed.caption,
                                      rating: currentFeed.saloonOwner != null
                                          ? "${currentFeed.saloonOwner!.avgRating?.toStringAsFixed(1)} ★ (${currentFeed.saloonOwner!.ratingCount.toString()})"
                                          : "",
                                      onFavoritePressed: (isFavorite) {
                                        controller.toggleLikeFeed(
                                          feedId: currentFeed.id,
                                          isUnlike: isFavorite == true,
                                        );
                                      },
                                      onVisitShopPressed: () {
                                        if (currentFeed.saloonOwner != null) {
                                          // controller.getSelonData(
                                          //     userId:
                                          //         currentFeed.saloonOwner!.userId);
                                          AppRouter.route.pushNamed(
                                            RoutePath.shopProfileScreen,
                                            extra: {
                                              'userRole': userRole,
                                              'userId': currentFeed
                                                  .saloonOwner!.userId,
                                              'controller': controller,
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.check_circle,
              color: Colors.orange,
              size: 50.0,
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0.h),
            const Text(
              'You have completed the job.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home or any other action you want
                Navigator.pop(context); // Close the BottomSheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // button color
                minimumSize:
                    const Size(double.infinity, 50), // full-width button
              ),
              child: const Text(
                'Go to Home',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
