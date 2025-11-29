import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
import 'package:barber_time/app/view/common_widgets/show_custom_snackbar/show_custom_snackbar.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_favorite/models/favorite_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<Widget> buildFeedCards(
    UserRole? userRole, List<FavoriteFeedItem> items, controller) {
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
        postImageUrl:
            item.images.isNotEmpty ? item.images.first : AppConstants.demoImage,
        postText: item.caption,
        rating: ratingStr,
        onFavoritePressed: (isFavorite) async {
          // Optimistically remove the item from the list for instant UI update
          items.removeWhere((fav) => fav.feedId == item.feedId);
          // Call the API to toggle like/unlike
          final bool result = await controller.toggleLikeFeed(
            feedId: item.feedId,
            isUnlike: isFavorite == true,
          );
          debugPrint("Toggle favorite result: $result");

          if (!result) {
            // If the API call failed, re-add the item back to the list
            items.add(item);
            toastMessage(message: 'Failed to update favorite status');
          }
          if (result) {
            // Optionally, refresh the favorites list in the background for consistency
            // controller.fetchAllFavourite();
            controller.getHomeFeeds();
          }
        },
        onVisitShopPressed: () {
          if (item.saloonOwner != null) {
            AppRouter.route.pushNamed(
              RoutePath.shopProfileScreen,
              extra: {
                'userRole': userRole,
                'userId': item.saloonOwner!.userId,
                'controller': controller,
              },
            );
          }
        },
      ),
    );
  }).toList();
}
