import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/screens/barber/barber_home/controller/barber_home_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/settings/info_controller/info_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/models/favorite_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({
    super.key,
  });
  final InfoController infoController = Get.find<InfoController>();
    final BarberHomeController controller = Get.find<BarberHomeController>();


  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.linearFirst,
        title: const Text(AppStrings.myFavorite),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          if (infoController.isLoading.value) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => const _FavoriteShimmerCard(),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: 3,
            );
          }

          final display = infoController.favoriteItems;
        
          // Check if the list is empty
          if (display.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await infoController.fetchAllFavourite();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No Favorites Yet',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Start adding your favorite posts\nto see them here',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        
          return RefreshIndicator(
            onRefresh: () async {
              await infoController.fetchAllFavourite();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: _buildFeedCards(userRole, display),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildFeedCards(
      UserRole? userRole, List<FavoriteFeedItem> items) {
    return items.map((item) {
      final owner = item.saloonOwner;
      final shopName = owner?.shopName ?? 'Unknown Shop';
      final ratingStr = owner?.avgRating != null
          ? '${owner!.avgRating!.toStringAsFixed(1)} * (${owner.ratingCount ?? 0})'
          : '0.0 * (0)';

      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: CustomFeedCard(
          
          isFavouriteFromApi: true, // Always true since this is favorites list
          isVisitShopButton: item.saloonOwner != null,
          isFromFav: true,
          favoriteCount: "0", // Not available in favorite feed model
          userImageUrl: item.profileImage ?? AppConstants.demoImage,
          userName: shopName,
          userAddress: item.saloonOwner?.shopAddress ?? '',
          postImageUrl: item.images.isNotEmpty
              ? item.images.first
              : AppConstants.demoImage,
          postText: item.caption,
          rating: ratingStr,
          onFavoritePressed: (isFavorite) async {
             controller.toggleLikeFeed(
              feedId: item.feedId, 
              isUnlike: isFavorite == true,
            );
            // Refresh the favorites list after toggling
            await infoController.fetchAllFavourite();
          },
          onVisitShopPressed: () {
            if (item.saloonOwner != null) {
              AppRouter.route.pushNamed(
                RoutePath.shopProfileScreen,
                extra: {
                  'userRole': userRole,
                  'userId': item.saloonOwner!.userId,
                },
              );
            }
          },
        ),
      );
    }).toList();
  }


}

class _FavoriteShimmerCard extends StatelessWidget {
  const _FavoriteShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row (avatar + name + address)
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 12,
                            child: ColoredBox(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 6.0),
                        child: SizedBox(
                            width: 160,
                            height: 12,
                            child: ColoredBox(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // Large post image placeholder
            Container(
              height: 364,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 8),
            // Post text placeholder
            const SizedBox(
                width: double.infinity,
                height: 14,
                child: ColoredBox(color: Colors.white)),
            const SizedBox(height: 10),
            // Bottom action row: favorite circle, rating, visit shop button
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.secondary, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                    width: 80,
                    height: 14,
                    child: ColoredBox(color: Colors.white)),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: AppColors.black),
                  child: const SizedBox(
                      width: 80,
                      height: 20,
                      child: ColoredBox(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
