import 'package:barber_time/app/core/custom_assets/assets.gen.dart';
import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/global/helper/extension/extension.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:barber_time/app/view/common_widgets/common_shop_card/common_shop_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_card/custom_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/common_widgets/custom_title/custom_title.dart';
import 'package:barber_time/app/view/screens/user/home/controller/user_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/personal_info/controller/owner_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widgets/user_nav_bar/user_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final UserHomeController homeController = Get.find<UserHomeController>();
  final OwnerProfileController profileController =
      Get.find<OwnerProfileController>();

  @override
  Widget build(BuildContext context) {
    final extra = GoRouter.of(context).state.extra;

    UserRole? userRole;
    if (extra is UserRole) {
      userRole = extra;
    } else if (extra is String) {
      userRole = getRoleFromString(extra);
    } else if (extra is Map && extra['role'] != null) {
      userRole = getRoleFromString(extra['role'].toString());
    }

    // If role is not available from route extra, get it from SharedPreferences
    if (userRole == null) {
      return FutureBuilder<String>(
        future: SharePrefsHelper.getString(AppConstants.role),
        builder: (context, snapshot) {
          // Wait for the future to complete before making decisions
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading state or use default while loading
            return _buildScaffold(context, UserRole.user);
          }

          // Future is done, check if we have data
          final resolvedRole = snapshot.hasData && snapshot.data!.isNotEmpty
              ? getRoleFromString(snapshot.data!)
              : UserRole.user;

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            debugPrint(
                'HomeScreen: role loaded from SharedPreferences: ${resolvedRole.name}');
          } else {
            // No data available after future completes
            debugPrint(
                'HomeScreen: no role found in route extra or SharedPreferences; defaulting to CUSTOMER');
          }

          return _buildScaffold(context, resolvedRole);
        },
      );
    }

    return _buildScaffold(context, userRole);
  }

  Widget _buildScaffold(BuildContext context, UserRole userRole) {
    return Scaffold(
      bottomNavigationBar: CustomNavBar(currentIndex: 0, role: userRole),
      body: Column(
        children: [
          /// 🏡 Common Home AppBar
          Obx(() {
            final hasProfile = profileController.profileDataList.value != null;
            if (!hasProfile) {
              return SafeArea(
                child: Padding(
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
                      // Search and notification icons keep their actions
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          AppRouter.route
                              .pushNamed(RoutePath.searchSaloonScreen, extra: {
                            'userRole': userRole,
                          });
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
                ),
              );
            }

            // When profile data is available show the regular app bar
            final profile = profileController.profileDataList.value!;
            return CommonHomeAppBar(
              isSearch: true,
              onSearch: () => AppRouter.route
                  .pushNamed(RoutePath.searchSaloonScreen, extra: {
                'userRole': userRole,
              }),
              scaffoldKey: scaffoldKey,
              name: profile.fullName.safeCap(),
              image: profile.image ?? '',
              onTap: () => AppRouter.route
                  .pushNamed(RoutePath.notificationScreen, extra: userRole),
            );
          }),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                          onTap: () {
                            homeController.fetchCustomerBookings(
                                bookingType: 'BOOKING');
                            AppRouter.route.pushNamed(
                                RoutePath.customerBookingScreen,
                                extra: {
                                  'userRole': userRole,
                                  'bookingType': 'Booking',
                                });
                          },
                          title: "Bookings",
                          icon: Assets.icons.bookings.svg()),
                      CustomCard(
                          onTap: () {
                            homeController.fetchLoyalityRewards();
                            AppRouter.route
                                .pushNamed(RoutePath.myLoyality, extra: {
                              'userRole': userRole,
                              'controller': homeController,
                            });
                          },
                          title: "Loyalty",
                          icon: Assets.icons.loyalitys.svg()),
                      CustomCard(
                          onTap: () {
                            // AppRouter.route.pushNamed(RoutePath.scannerScreen,
                            //     extra: userRole);
                            homeController.fetchCustomerBookings(
                                isDateWise: true, bookingType: 'queue');
                            AppRouter.route.pushNamed(
                                RoutePath.customerBookingScreen,
                                extra: {
                                  'userRole': userRole,
                                  'bookingType': 'queue',
                                });
                          },
                          title: "Queue",
                          icon: Assets.icons.ques.svg()),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomCard(
                          // here will be rate screen navigation
                          onTap: () {
                            homeController.fetchCustomerReviews();
                            AppRouter.route.pushNamed(
                                RoutePath.customerReviewScreen,
                                extra: {
                                  'userRole': userRole,
                                  'controller': homeController,
                                });
                          },
                          title: "Review",
                          icon: Assets.icons.reviews.svg()),
                      CustomCard(
                          onTap: () {
                            _showTipDialog(context, userRole);
                          },
                          title: "Tips",
                          icon: Assets.icons.tips.svg(height: 35)),
                      CustomCard(
                          onTap: () {
                            AppRouter.route
                                .pushNamed(RoutePath.SelectedMapScreen, extra: {
                              'userRole': userRole,
                              'nearbySalons':
                                  homeController.nearbySaloons.toList(),
                              'showNearbySalons': true,
                            });
                          },
                          title: "MapView",
                          icon: Assets.icons.mapview.svg()),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  /// 🔥 Near You Section
                  CustomTitle(
                    title: AppStrings.nearYou,
                    actionText: AppStrings.seeAll,
                    onActionTap: () => AppRouter.route
                        .pushNamed(RoutePath.nearYouShopScreen, extra: {
                      'userRole': userRole,
                    }),
                    actionColor: AppColors.secondary,
                  ),
                  SizedBox(height: 12.h),

                  /// 📌 Nerby  Scroll for Shops

                  SizedBox(
                    height: 245.h,
                    child: Obx(
                      () {
                        if (homeController.fetchStatus.value.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.app,
                            ),
                          );
                        } else if (homeController.fetchStatus.value.isError) {
                          return Center(
                            child: CustomText(
                              text: "Error loading salons",
                              color: AppColors.red,
                            ),
                          );
                        } else if (homeController.nearbySaloons.isEmpty) {
                          return Center(
                            child: CustomText(
                              text: "No salons found nearby",
                              color: AppColors.black,
                            ),
                          );
                        } else {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeController.nearbySaloons.length > 10
                                ? 10
                                : homeController.nearbySaloons.length,
                            itemBuilder: (context, index) {
                              final salon = homeController.nearbySaloons[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    AppRouter.route.pushNamed(
                                      RoutePath.shopProfileScreen,
                                      extra: {
                                        'userRole': userRole,
                                        'userId': salon.userId,
                                        'controller': homeController,
                                      },
                                    );
                                    // context.pushNamed(
                                    //     RoutePath.userBookingScreen,
                                    //     extra: userRole);
                                  },
                                  child: CommonShopCard(
                                    imageUrl: salon.shopLogo,
                                    title: salon.shopName,
                                    rating: "${salon.ratingCount} ★",
                                    location: salon.shopAddress,
                                    discount: salon.distance.toString(),
                                    isSaved: salon.isFavorite,
                                    totalQueueCount: salon.totalQueueCount,
                                    totalAvailableBarbers:
                                        salon.totalAvailableBarbers,
                                    onSaved: () {
                                      homeController.toggleFavoriteSalon(
                                        tag: tags.nearby,
                                        salonId: salon.userId,
                                        isFavorite: salon.isFavorite,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(width: 10.w),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// 🌟 Top Rated Section
                  CustomTitle(
                    title: "Top Rated",
                    actionText: AppStrings.seeAll,
                    onActionTap: () => AppRouter.route
                        .pushNamed(RoutePath.topRatedScreen, extra: {
                      'userRole': userRole,
                    }),
                    actionColor: AppColors.secondary,
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 245.h,
                    child: Obx(
                      () {
                        if (homeController.fetchStatus.value.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.app,
                            ),
                          );
                        } else if (homeController.fetchStatus.value.isError) {
                          return Center(
                            child: CustomText(
                              text: "Error loading salons",
                              color: AppColors.red,
                            ),
                          );
                        } else if (homeController.topRatedSaloons.isEmpty) {
                          return Center(
                            child: CustomText(
                              text: "No top rated salons found",
                              color: AppColors.black,
                            ),
                          );
                        } else {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                homeController.topRatedSaloons.length > 10
                                    ? 10
                                    : homeController.topRatedSaloons.length,
                            itemBuilder: (context, index) {
                              final salon =
                                  homeController.topRatedSaloons[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    // context.pushNamed(
                                    //     RoutePath.userBookingScreen,
                                    //     extra: userRole);
                                    AppRouter.route.pushNamed(
                                      RoutePath.shopProfileScreen,
                                      extra: {
                                        'userRole': userRole,
                                        'userId': salon.userId,
                                        'controller': homeController,
                                      },
                                    );
                                  },
                                  child: CommonShopCard(
                                    imageUrl: salon.shopLogo,
                                    title: salon.shopName,
                                    rating: "${salon.ratingCount} ★",
                                    location: salon.shopAddress,
                                    discount: salon.distance.toString(),
                                    isSaved: salon.isFavorite,
                                    totalQueueCount: salon.totalQueueCount,
                                    totalAvailableBarbers:
                                        salon.totalAvailableBarbers,
                                    onSaved: () {
                                      homeController.toggleFavoriteSalon(
                                        tag: tags.topRated,
                                        salonId: salon.userId,
                                        isFavorite: salon.isFavorite,
                                        index: index,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(width: 10.w),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),

                  /// 📢 Feed Section
                  CustomTitle(
                    title: "Feed",
                    actionText: AppStrings.seeAll,
                    onActionTap: () {
                      AppRouter.route.pushNamed(RoutePath.feedAll, extra: {
                        'userRole': userRole,
                        'controller': homeController,
                      });
                    },
                    actionColor: AppColors.secondary,
                  ),

                  SizedBox(
                    height: 12.h,
                  ),
                  Obx(() {
                    final feeds = homeController.homeFeedsList;
                    if (homeController.getFeedsStatus.value.isLoading) {
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
                        final feed = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Obx(() {
                            // Access feed directly from controller to ensure reactivity
                            final currentFeed =
                                homeController.homeFeedsList[index];
                            return CustomFeedCard(
                              isFavouriteFromApi:
                                  currentFeed.isFavorite ?? false,
                              isVisitShopButton: feed.saloonOwner != null,
                              favoriteCount:
                                  currentFeed.favoriteCount.toString(),
                              userImageUrl:
                                  feed.userImage ?? AppConstants.demoImage,
                              userName: feed.userName,
                              userAddress: feed.saloonOwner?.shopAddress ?? '',
                              postImageUrl: feed.images.isNotEmpty
                                  ? feed.images.first
                                  : AppConstants.demoImage,
                              postText: feed.caption,
                              rating: feed.saloonOwner != null
                                  ? "${feed.saloonOwner!.avgRating?.toStringAsFixed(1)} ★ (${feed.saloonOwner!.ratingCount})"
                                  : "",
                              onFavoritePressed: (isFavorite) {
                                homeController.toggleLikeFeed(
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
                                      'controller': homeController,
                                    },
                                  );
                                }
                              },
                            );
                          }),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the Tip dialog
  void _showTipDialog(BuildContext context, UserRole userRole) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.white,
          title: Column(
            children: [
              const Icon(
                Icons.attach_money,
                color: Colors.orange,
                size: 40,
              ),
              const Text(
                "Tip",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              CustomText(
                maxLines: 2,
                text: "Would you like to leave this or barber a tip?",
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                fontSize: 15.sp,
              )
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Yes button
              _buildRadioButton("Yes", context, () {
                AppRouter.route
                    .pushNamed(RoutePath.tipsScreen, extra: userRole);
              }),
              const SizedBox(width: 20),
              // No button
              _buildRadioButton("No", context, () {
                context.pop();
              }),
            ],
          ),
          actions: <Widget>[
            // Close button
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

  // Helper method to create radio-like buttons for Yes/No selection
  Widget _buildRadioButton(
      String label, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.orange, fontSize: 16),
        ),
      ),
    );
  }
}
