import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_feed_card/custom_feed_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final userRole = GoRouter.of(context).state.extra as UserRole?;

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

          final favorites = infoController.favoriteItems;
          final display = favorites.isEmpty ? _demoFavorites : favorites;

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
      final image =
          item.images.isNotEmpty ? item.images.first : AppConstants.demoImage;
      final shopName = owner?.shopName ?? 'Unknown Shop';
      final ratingStr = owner?.avgRating != null
          ? '${owner!.avgRating!.toStringAsFixed(1)} * (${owner.ratingCount ?? 0})'
          : '0.0 * (0)';

      return CustomFeedCard(
        userImageUrl: item.profileImage ?? AppConstants.demoImage,
        userName: item.userId.isNotEmpty ? item.userId : shopName,
        userAddress: owner?.shopAddress ?? '',
        postImageUrl: image,
        postText: item.caption.isNotEmpty ? item.caption : '',
        rating: ratingStr,
        onFavoritePressed: (isFavorite) {
          // Demo favorite pressed
        },
        onVisitShopPressed: () {
          AppRouter.route.pushNamed(RoutePath.visitShop, extra: userRole);
        },
      );
    }).toList();
  }

  // Demo favorites to show when API returns empty.
  List<FavoriteFeedItem> get _demoFavorites => [
        FavoriteFeedItem(
          id: '68a7073aaff8297056410356',
          feedId: '68a7073aaff8297056410356',
          caption: 'Fresh new haircut styles available this week! Bye',
          images: [
            'https://lerirides.nyc3.digitaloceanspaces.com/feed-images/1755776825516_man-9377284_1280.jpg'
          ],
          userId: 'John Updated',
          profileImage: null,
          saloonOwner: SaloonOwner(
            userId: '689424ee19c117b142c8bf50',
            shopName: 'Elite Saloon',
            registration: 'REG123456',
            shopAddress: '123 Main Street, Dhaka',
            shopImages: [],
            shopVideo: [],
            shopLogo:
                'https://lerirides.nyc3.digitaloceanspaces.com/saloon-logos/1754542797566_icon-6951393_1280.jpg',
            avgRating: 4.5,
            ratingCount: 2,
          ),
        ),
      ];
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
