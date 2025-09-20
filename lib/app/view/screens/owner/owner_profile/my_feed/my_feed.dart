import 'package:barber_time/app/core/route_path.dart';
import 'package:barber_time/app/core/routes.dart';
import 'package:barber_time/app/utils/app_colors.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:barber_time/app/utils/app_strings.dart';
import 'package:barber_time/app/utils/enums/user_role.dart';
import 'package:barber_time/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:barber_time/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:barber_time/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:barber_time/app/view/screens/barber/barber_feed/barber_feed_controller.dart';
import 'package:barber_time/app/view/screens/owner/owner_profile/my_feed/model/feed_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MyFeed extends StatelessWidget {
  MyFeed({
    super.key,
  });

  final BarberFeedController feedController = Get.find<BarberFeedController>();

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
        title: const Text(AppStrings.myFeedBack),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(() {
          if (feedController.isLoadingFeeds.value) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => const _MyFeedShimmerCard(),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: 3,
            );
          }

          final feeds = feedController.allFeeds;
          final display = feeds.isEmpty ? _demoFeed : feeds;

          return RefreshIndicator(
            onRefresh: () async => await feedController.getAllFeeds(),
            child: display.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 80),
                      Center(child: Text('No feeds available')),
                    ],
                  )
                : ListView.builder(
                    itemCount: display.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final item = display[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: _MyFeedCard(
                          item: item,
                          onFavoritePressed: () {
                            // infoController.toggleFavorite(item.id);
                          },
                          onEditPressed: () {
                            AppRouter.route
                                .goNamed(RoutePath.barberFeed, extra: {
                              "isEdit": true,
                              "feedItem": item,
                              "userRole": userRole,
                              "image": item.images.isNotEmpty
                                  ? item.images.first
                                  : null,
                            });
                          },
                          onDeletePressed: () {
                            feedController.deleteFeed(item.id);
                          },
                          onVisitShopPressed: () => AppRouter.route
                              .goNamed(RoutePath.visitShop, extra: userRole),
                        ),
                      );
                    },
                  ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: CustomButton(
          onTap: () {
            AppRouter.route.goNamed(RoutePath.barberFeed, extra: userRole);
          },
          fillColor: AppColors.black,
          title: AppStrings.addFeed,
          textColor: AppColors.white50,
        ),
      ),
    );
  }
}

List<FeedItem> get _demoFeed => [
      FeedItem(
        id: '68a70729aff8297056410355',
        userId: '689424ee19c117b142c8bf50',
        userName: 'John Updated',
        userImage: null,
        saloonOwner: SaloonOwner(
          userId: '689424ee19c117b142c8bf50',
          shopName: 'Elite Saloon',
          shopAddress: '123 Main Street, Dhaka',
          shopImages: [],
          shopVideo: [],
          shopLogo:
              'https://lerirides.nyc3.digitaloceanspaces.com/saloon-logos/1754542797566_icon-6951393_1280.jpg',
          avgRating: 4.5,
          ratingCount: 2,
        ),
        caption: 'Fresh new haircut styles available this week!',
        images: [
          'https://lerirides.nyc3.digitaloceanspaces.com/feed-images/1755776807812_man-9377284_1280.jpg'
        ],
        favoriteCount: 5,
      ),
    ];

class _MyFeedCard extends StatelessWidget {
  final FeedItem item;
  final VoidCallback onFavoritePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onVisitShopPressed;
  final VoidCallback onDeletePressed;

  const _MyFeedCard(
      {required this.item,
      required this.onFavoritePressed,
      required this.onEditPressed,
      required this.onVisitShopPressed,
      required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    final owner = item.saloonOwner;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                boxShape: BoxShape.circle,
                imageUrl: owner?.shopLogo ?? AppConstants.demoImage,
                height: 48,
                width: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: owner?.shopName ?? item.userName,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StarRating(rating: owner?.avgRating ?? 0),
                        const SizedBox(width: 6),
                        CustomText(
                          text: '(${owner?.ratingCount ?? 0})',
                          fontSize: 12,
                          color: AppColors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onFavoritePressed,
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                  ),
                  CustomText(
                    text: '${item.favoriteCount ?? 0}',
                    fontSize: 12,
                    color: AppColors.black,
                  ),
                ],
              ),
              PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 1) onEditPressed();
                  if (value == 2) onDeletePressed();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 1, child: Text('Edit')),
                  const PopupMenuItem(value: 2, child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (item.images.isNotEmpty)
            CustomNetworkImage(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              imageUrl: item.images.first,
              height: 220,
              width: double.infinity,
            ),
          const SizedBox(height: 8),
          CustomText(
            text: item.caption,
            fontSize: 14,
            color: AppColors.black,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onVisitShopPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomText(
                text: 'Visit Shop',
                fontSize: 12,
                color: AppColors.white50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    final stars = List<Widget>.generate(5, (index) {
      final starIndex = index + 1;
      IconData icon;
      if (rating >= starIndex) {
        icon = Icons.star;
      } else if (rating > index && rating < starIndex) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      return Icon(icon, size: 14, color: Colors.amber);
    });
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

class _MyFeedShimmerCard extends StatelessWidget {
  const _MyFeedShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      SizedBox(
                          width: double.infinity,
                          height: 12,
                          child: ColoredBox(color: Colors.white)),
                      SizedBox(height: 6),
                      SizedBox(
                          width: 80,
                          height: 10,
                          child: ColoredBox(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: const [
                    SizedBox(
                        width: 28,
                        height: 28,
                        child: ColoredBox(color: Colors.white)),
                    SizedBox(height: 6),
                    SizedBox(
                        width: 20,
                        height: 10,
                        child: ColoredBox(color: Colors.white)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            const SizedBox(height: 8),
            const SizedBox(
                width: double.infinity,
                height: 12,
                child: ColoredBox(color: Colors.white)),
            const SizedBox(height: 8),
            Container(
                width: 90,
                height: 28,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
          ],
        ),
      ),
    );
  }
}
