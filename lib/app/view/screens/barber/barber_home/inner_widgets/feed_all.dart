import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/mixin/mixin_feeds_management.dart';
import 'package:barber_time/app/view/screens/owner/owner_home/controller/barber_owner_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class FeedAll extends StatelessWidget {
  FeedAll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;
    UserRole? userRole;
    dynamic controller;

    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is Map<String, dynamic>) {
      userRole = extra['userRole'] as UserRole?;
      controller = extra['controller'];
    }

    // If no controller passed, try to find based on user role
    if (controller == null) {
      try {
        if (userRole == UserRole.barber) {
          controller = Get.find<BarberHomeController>();
        } else {
          controller = Get.find<BarberOwnerHomeController>();
        }
      } catch (e) {
        debugPrint("Error finding controller: $e");
      }
    }

    debugPrint("===================${userRole?.name}");
    if (userRole == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No user role received')),
      );
    }

    if (controller == null || controller is! MixinFeedsManagement) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Controller not found')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.feed),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          final feeds = controller.homeFeedsList;

          if (controller.getFeedsStatus.value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (feeds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feed_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No feeds available',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Check back later for new content',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: feeds.asMap().entries.map<Widget>((entry) {
                final index = entry.key;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Obx(() {
                    final feedController = controller as MixinFeedsManagement;
                    final currentFeed = feedController.homeFeedsList[index];
                    return CustomFeedCard(
                      isFavouriteFromApi: currentFeed.isFavorite ?? false,
                      isVisitShopButton: currentFeed.saloonOwner != null,
                      favoriteCount: currentFeed.favoriteCount.toString(),
                      userImageUrl: currentFeed.userImage ?? AppConstants.demoImage,
                      userName: currentFeed.userName,
                      userAddress: currentFeed.saloonOwner?.shopAddress ?? '',
                      postImageUrl: currentFeed.images.isNotEmpty
                          ? currentFeed.images.first
                          : AppConstants.demoImage,
                      postText: currentFeed.caption,
                      rating: currentFeed.saloonOwner != null
                          ? "${currentFeed.saloonOwner!.avgRating?.toStringAsFixed(1)} ★ (${currentFeed.saloonOwner!.ratingCount.toString()})"
                          : "",
                      onFavoritePressed: (isFavorite) {
                        feedController.toggleLikeFeed(
                          feedId: currentFeed.id,
                          isUnlike: isFavorite == true,
                        );
                      },
                      onVisitShopPressed: () {
                        if (currentFeed.saloonOwner != null) {
                          AppRouter.route.pushNamed(
                            RoutePath.shopProfileScreen,
                            extra: {
                              'userRole': userRole,
                              'userId': currentFeed.saloonOwner!.userId,
                              'controller': controller,
                            },
                          );
                        }
                      },
                    );
                  }),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }
}
